class AttachAccuracyForPnt < ActiveRecord::Migration[5.0]
  def up
    ExperimentTrial.where(:kind => 0).update_all(:answer => 1)

    {
      "18700922023" => [13,16,29,40,53,75,77,82,103,111],
      "18392619082" => [34,121],
      "15739362329" => [1,23],
      "18700871702" => [13,14,39,48,56,57,107,114,120,128],
      "13899130829" => [20,102],
      "18191329937" => [16,23],
      "15529207360" => [8],
      "18706873176" => [5,6,37,70,82,104,118],
      "18299693096" => [1,22,62,73,74],
      "15686065931" => [22],
      "15529208771" => [43,46,59,61,65,66,69,73,77,84,85,91,99,105,109,121,129],
      "18392090980" => [31,65,98,124],
      "15529372721" => [7,30,48,71,88,94,106,114,121,131],
      "15686291353" => [24,45,62,81],
      "18199713867" => [18,22,84,85],
      "17690102545" => [20,47,64,79,92,121],
      "15686065903" => [55,68,88,116],
      "18392008390" => [15,47,51],
      "15502930697" => [3,9,18,19,32,81,118,128],
      "15029202958" => [7,16,24,69],
      "17809298318" => [11,14,85],
      "18099024020" => [29,50],
      "17691131913" => [12,27,59,68,70,85,92,114],
      "17691142774" => [52,69,94],
      "15502937215" => [8,21,52,78,93,129],
      "15529307735" => [9,18,29,32,41,46,55,65,75,97,106,112,123,130,131,132],
      "15109201682" => [8,9,24,33,61,96,123],
      "18729011283" => [],
      "18629297644" => [5,35,43,73,101,116],
      "18742797358" => [9,30,50,78],
      "18997859815" => [16,30,38,80,89,96],
      "13379745844" => [8,12,29],
      "18092771586" => [9,10,12,13,24,28,34,37,48,57,62,69,91,101,109,113,125,126],
      "17829822981" => [5,57,60,101],
      "13319265592" => [68],
      "18792960075" => [6,23,45,96,117],
      "18729566117" => [24,30,31,54,70,71,80,89,124],
      "18392897568" => [16,32,50,56,87],
      "18710363813" => [15,56],
      "15529206171" => [45,86,109],
      "15686065952" => [8,64],
      "18700872951" => [105],
      "18821625100" => [34,68],
      "18392526019" => [15,16,24,25,31,36,41,58,65,76,83,87,117],
      "13991327231" => [32,47,64,81,121],
      "18729022891" => [124],
      "18710616821" => [24,107,123],
      "18829208733" => [10,60,62,116,126,127],
      "18699823066" => [92,105,127],
      "13289210921" => [32,39,48,102,122],
      "18202989015" => [45,79],
      "15771970155" => [31,62,67],
      "15771939956" => [17,18,80,99],
      "15304316295" => [1,8,13,22,26,28,32,42,44,60,61,64,72,74,80,88,92,104,116,123],
      "13279959017" => [25,34],
      "15686065969" => [6,61,63,131],
      "18392111081" => [23],
      "17795833060" => [20,45,93,114,127],
      "15686065965" => [36],
      "18392655323" => [15,29,43,56,78,93,120,130],
      "18291919253" => [55,100,102],
      "15529221172" => [16,21,54,60,71,102,107],
      "18392677617" => [27,82,97],
      "18392597060" => [18,36,70],
      "18392591330" => [26,27,34,49,61,72,78,113],
      "15686065893" => [10,44],
      "18821638521" => [9,12,24,94],
      "18092771327" => [31,42,44,64],
      "18392629960" => [59,120],
      "17829823073" => [26,49,126],
      "15686065930" => [18,24,29,35,38,43,46,50,55,64,77,88,95,106,111,122],
      "18709225360" => [12,19,25,38,39,44,69,77],
      "18629064247" => [40],
      "17690173025" => [41,78,82,95,110,129],
      "18095884757" => [14,47,53,57,73],
      "18299917844" => [50,97,104,109,113,117],
      "18729092877" => [10,35,85,107],
      "18699892786" => [7,30,55,56,107],
      "18792735991" => [22,25,27,57,68],
      "18792721620" => [6],
      "17809299455" => [6,24,46,73,92,101],
      "15229287131" => [58,113],
      "15596656027" => [53,81,84,100],
      "15702930803" => [24],
      "18199328838" => [18,19,24,27,32,38,66,79,109,113,122,126]
    }.each do |phone, numbers|
      if numbers.count > 0
        ExperimentTrial.where('`key` = ? AND seq IN (?)', phone, numbers).update_all(:answer => 0)
      end
    end

    {
      "18700922023" => [],
      "18392619082" => [14],
      "15739362329" => [],
      "18700871702" => [],
      "13899130829" => [19,59,92,107,116,132],
      "18191329937" => [],
      "15529207360" => [16],
      "18706873176" => [],
      "18299693096" => [],
      "15686065931" => [],
      "15529208771" => [11,21,24,42,48,49,68,70,76,89],
      "18392090980" => [],
      "15529372721" => [],
      "15686291353" => [],
      "18199713867" => [],
      "17690102545" => [25],
      "15686065903" => [],
      "18392008390" => [28,42],
      "15502930697" => [],
      "15029202958" => [],
      "17809298318" => [],
      "18099024020" => [],
      "17691131913" => [],
      "17691142774" => [],
      "15502937215" => [],
      "15529307735" => [12,24,44,52,71,74,80,88,109,111,119],
      "15109201682" => [],
      "18729011283" => [13,17],
      "18629297644" => [68,104],
      "18742797358" => [115],
      "18997859815" => [],
      "13379745844" => [],
      "18092771586" => [39,84],
      "17829822981" => [],
      "13319265592" => [29],
      "18792960075" => [24],
      "18729566117" => [83,84],
      "18392897568" => [78],
      "18710363813" => [],
      "15529206171" => [21],
      "15686065952" => [],
      "18700872951" => [6],
      "18821625100" => [],
      "18392526019" => [],
      "13991327231" => [],
      "18729022891" => [],
      "18710616821" => [],
      "18829208733" => [],
      "18699823066" => [3,15,35,46,48,72],
      "13289210921" => [12,91],
      "18202989015" => [],
      "15771970155" => [5,41,47,59,71],
      "15771939956" => [28,46,88,129],
      "15304316295" => [43,85],
      "13279959017" => [15],
      "15686065969" => [82],
      "18392111081" => [],
      "17795833060" => [],
      "15686065965" => [],
      "18392655323" => [],
      "18291919253" => [],
      "15529221172" => [],
      "18392677617" => [],
      "18392597060" => [],
      "18392591330" => [],
      "15686065893" => [],
      "18821638521" => [],
      "18092771327" => [16,27,83,100,128],
      "18392629960" => [],
      "17829823073" => [48,130],
      "15686065930" => [6],
      "18709225360" => [],
      "18629064247" => [8,19,85,87,115,119],
      "17690173025" => [],
      "18095884757" => [],
      "18299917844" => [],
      "18729092877" => [],
      "18699892786" => [],
      "18792735991" => [1,12,23,31,37,49,67,72,86,91,107,125],
      "18792721620" => [],
      "17809299455" => [],
      "15229287131" => [],
      "15596656027" => [],
      "15702930803" => [36,74],
      "18199328838" => [9]
    }.each do |phone, numbers|
      if numbers.count > 0
        ExperimentTrial.where('`key` = ? AND seq IN (?)', phone, numbers).update_all(:answer => nil)
      end
    end
  end

  def down
    ExperimentTrial.where(:kind => 0).update_all(:answer => nil)
  end
end
