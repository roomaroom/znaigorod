module Yandex
  class Culture < Company
    def rubrics
      libraries          = '184105838'
      museums            = '184105894'
      theaters           = '184105872'
      recreation_centers = '184105876'
      philharmonics      = '184105918'
      planateries        = '184106370'

      result = []

      result << libraries          if suborganization.categories.include?('Библиотеки')
      result << museums            if suborganization.categories.include?('Музеи')
      result << theaters           if suborganization.categories.include?('Театры')
      result << recreation_centers if suborganization.categories.include?('Дворцы культуры')
      result << philharmonics      if suborganization.categories.include?('Филармонии')
      result << planateries        if suborganization.categories.include?('Планетарии')

      result[0..2]
    end
  end
end

