class LeapqSampleLevel < ApplicationRecord
  def self.save(sampleId, rates, sampleLanguages)
    languageRates = {}
    rates.each do |way, languages|
      languages.each do |language, rate|
        languageRates[language] = languageRates[language] || {}
        languageRates[language][way.to_sym] = rate
      end
    end

    sampleLanguageIds = {}
    sampleLanguages.each do |sampleLanguage|
      sampleLanguageIds[sampleLanguage[:language_id]] = sampleLanguage[:id]
    end

    languageRates.each.map do |language, ways|
      languageId = LeapqLanguage.get_id_by_name(language)
      ways[:sample_id] = sampleId
      ways[:sample_language_id] = sampleLanguageIds[languageId]
      self.create(ways)
    end
  end
end
