module Yandex
  class Sport < Company
    def rubrics
      fitness      = '184107363'
      dance        = '184105924'
      sport_school = '184107305'
      rink         = '184107311'
      pool         = '184107275'
      yoga         = '184107361'
      racetrack    = '184107285'
      stadium      = '184107315'
      skiing_lodge = '184107293'
      sports_club  = '184107297'
      horse        = '184107287'

      result = []

      result << fitness      if suborganization.categories.include?('Фитнес')
      result << dance        if suborganization.categories.include?('Танцы')
      result << sport_school if suborganization.categories.include?('Спортивные школы')
      result << rink         if suborganization.categories.include?('Катки')
      result << pool         if suborganization.categories.include?('Бассейны')
      result << yoga         if suborganization.categories.include?('Йога')
      result << racetrack    if suborganization.categories.include?('Ипподромы')
      result << stadium      if suborganization.categories.include?('Стадионы')
      result << skiing_lodge if suborganization.categories.include?('Лыжные базы')
      result << sports_club  if suborganization.categories.include?('Профессиональные спортивные клубы')
      result << horse        if suborganization.categories.include?('Конные клубы')

      result[0..2]
    end

    def images
      suborganization.organization.gallery_images +
        suborganization.gallery_images
    end
  end
end

