module Yandex
  class Creation < Company
    def rubrics
      photos =    '4231264634'
      languages = '184106160'
      cinemas =   '184105866'

      result = []

      result << photos    if suborganization.categories.include?('Фотошколы')
      result << languages if suborganization.categories.include?('Иностранные языки')
      result << cinemas   if suborganization.categories.include?('Киностудии')

      result[0..2]
    end

    def images
      suborganization.organization.gallery_images +
        suborganization.gallery_images
    end
  end
end

