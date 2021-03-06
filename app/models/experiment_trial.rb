class ExperimentTrial < ApplicationRecord
  enum kind: [:pic, :lex_cn, :lex_ug, :flanker, :simon, :iq]

  def self.import page
    results = ExperimentResult.all
    mergedResults = self.merge results
    trials = self.get_trial mergedResults

    size = 10000
    limitedTrials = trials.slice((page - 1) * size, size)
    self.create(limitedTrials)
  end

  def self.list kind
    trials = self.select('*, lsi.code AS code')
      .joins('LEFT JOIN leapq_samples AS ls ON ls.phone = experiment_trials.key AND ls.is_active ')
      .joins('LEFT JOIN leapq_sample_infos AS lsi ON lsi.sample_id = ls.id ')
      .where({ :kind => kind }).order('lsi.code ASC')
  end

  def to_hash threshold
    item = Hash.new
    item[:accuracy] = self.accuracy
    item[:key] = self.key
    item[:correct] = self.correct
    item[:combination] = self.combination
    item[:speed] = self.speed
    item[:seq] = self.seq
    item[:code] = self.code
    item[:min] = threshold[:min]
    item[:max] = threshold[:max]
    item[:std] = threshold[:std]
    if self.correct.present?
      overMax = item[:correct] > threshold[:max]
      lessMin = item[:correct] < threshold[:min]
      if overMax || lessMin
        item[:inlier] = nil
      else
        item[:inlier] = item[:correct]
      end
    end
    item
  end

  def self.thresholds records
    groups = records.group_by { |record| record.key }
    groups.transform_values do |records|
      self.threshold records
    end
  end

  def group
    @sample = Rails.cache.fetch("sample_#{self.key}", expires_in: 1.minute) do
      LeapqSample.find_by_phone(self.key)
    end
    @sample.leapq_sample_group.group
  end

  def correct
     self.accuracy ? self.speed : nil
  end

  def accuracy
    case self.kind.to_sym
    when :lex_ug, :lex_cn
      answer.present? && !answer.to_i.zero? == question['real']
    when :flanker
      answer.present? && !answer.to_i.zero? == (question['direction'] == 'right')
    when :simon
      answer.present? && !answer.to_i.zero? == (question['color'] == 'red')
    when :pic
      answer.present? && !answer.to_i.zero?
    else
      false
    end
  end

  def combination
    case self.kind.to_sym
    when :lex_ug, :lex_cn
      question['real'] ? 'word' : 'nonword'
    when :flanker
      question['congruent']
    when :simon
      isCon = (question['direction'] == 'left' && question['color'] == 'red') ||
        (question['direction'] == 'right' && question['color'] == 'blue')
      if question['direction'] == 'center'
        'neu'
      else
        isCon ? 'con' : 'incon'
      end
    when :pic
      switch = question['switch'] ? 'switch' : !question['begin'] ? 'keep' : ''
      lang = question['lang'] == 'chinese' ? 'cn' : 'ug'
      result = []
      if switch
        result.push(switch)
      end
      if lang
        result.push(lang)
      end
      result.join '_'
    else
      false
    end
  end

  private
  def self.threshold records
    accuracy_count = 0  
    sum = records.sum do |record|
      if record.answer.present?
        accuracy_count += 1
        record.speed
      else 
        0
      end
    end

    mean = (sum / accuracy_count).to_f

    variance = records.sum do |record|
      if record.answer.present?
        (record.speed - mean) ** 2
      else 
        0
      end
    end

    standard = Math.sqrt (variance / (accuracy_count - 1)).to_f

    min = mean - (2.5 * standard)
    max = mean + (2.5 * standard)
    {
      :min => min,
      :max => max,
      :std => self.efficient_standard(records, min, max)
    }
  end

  def self.efficient_standard(records, min, max)
    accuracy_count = 0
    sum = records.sum do |record|
      correct = record.answer.present? && record.answer
      inlier = record.speed > min && record.speed < max
      if (correct && inlier)
        accuracy_count += 1
        record.speed
      else 
        0
      end
    end

    mean = (sum / accuracy_count).to_f

    variance = records.sum do |record|
      correct = record.answer.present? && record.answer
      inlier = record.speed > min && record.speed < max
      if (correct && inlier)
        (record.speed - mean) ** 2
      else 
        0
      end
    end

    Math.sqrt (variance / (accuracy_count - 1)).to_f
  end

  def self.merge results
    mergedResults = Hash.new
    results.each_with_index do |result, index|
      resultName = result[:name]
      mergedResults[resultName] = mergedResults[resultName] || Hash.new
      [:pic, :lex_cn, :lex_ug, :flanker, :simon, :iq].each do |key|
        if mergedResults[resultName][key].nil?
          value = result[key].nil? ? nil : JSON.parse(result[key])
          mergedResults[resultName][key] = (value.nil? || value.empty?) ? nil : value
        end
      end
    end
    return mergedResults
  end

  def self.get_trial results
    trials = Array.new
    results.each_pair do |name, result|
      [:pic, :lex_cn, :lex_ug, :flanker, :simon, :iq].each do |kind|
        if result[kind].present?
          self.send "trial_by_#{kind}".to_sym, result[kind] do |trial|
            trial[:key] = name
            trial[:kind] = kind.to_s
            trials.push trial
          end
        end
      end
    end

    return trials
  end

  def self.trial_by_pic trials
    trials.each_with_index do |trial, index|
      record = {
        :raw => trial,
        :name => trial['name'],
        :seq => index + 1,
        :question => {
          :end => trial['isEnd'],
          :begin => (trial['switch'].eql? 'First'),
          :switch => (trial['switch'].eql? 'Changed'),
          :lang => trial['language']
        },
        :speed => trial['response']
      }

      yield record
    end
  end

  def self.trial_by_lex_cn trials
    trials.each_with_index do |trial, index|
      record = {
        :raw => trial,
        :name => trial['name'],
        :seq => index + 1,
        :question => {
          :real => !trial['isNon'],
          :lang => trial['language']
        },
        :answer => trial['selection'],
        :speed => trial['response']
      }

      yield record
    end
  end
  def self.trial_by_lex_ug trials
    self.trial_by_lex_cn trials do |trial|
      yield trial
    end
  end
  def self.trial_by_flanker trials
    trials.each_with_index do |trial, index|
      record = {
        :raw => trial,
        :name => "#{trial['type']}_#{trial['direction']}",
        :seq => index + 1,
        :question => {
          :congruent => trial['type'],
          :direction => trial['direction']
        },
        :answer => (trial['selection'].eql? 'right'),
        :speed => trial['response']
      }

      yield record
    end
  end
  def self.trial_by_simon trials
    trials.each_with_index do |trial, index|
      record = {
        :raw => trial,
        :name => "#{trial['type']}_#{trial['direction']}",
        :seq => index + 1,
        :question => {
          :color => trial['type'],
          :direction => trial['direction']
        },
        :answer => (trial['selection'].eql? 'red'),
        :speed => trial['response']
      }

      yield record
    end
  end
  def self.trial_by_iq trials
    trials.each_with_index do |trial, index|
      record = {
        :raw => trial,
        :name => trial['name'],
        :seq => index + 1,
        :question => trial['answer'],
        :answer => trial['choice'],
        :speed => trial['response']
      }

      yield record
    end
  end
end
