module Yandex
  class Entertainment < Company
    def rubrics
      night_clubs           = '184106368'
      billiard_clubs        = '184106358'
      paintball             = '184107369'
      entertainment_centers = '184106372'
      cimenas               = '184105868'
      attractions           = '184106354'
      bowling_clubs         = '184106360'

      result = []

      result << night_clubs           if suborganization.categories.include?('Ночные клубы')
      result << billiard_clubs        if suborganization.categories.include?('Бильярдные залы')
      result << paintball             if suborganization.categories.include?('Пейнтбол')
      result << entertainment_centers if suborganization.categories.include?('Развлекательные комплексы')
      result << cimenas               if suborganization.categories.include?('Кинотеатры')
      result << attractions           if suborganization.categories.include?('Аттракционы')
      result << bowling_clubs         if suborganization.categories.include?('Боулинг')

      result[0..2]
    end
  end
end

