module Yandex
  class Billiard < Company
    def rubrics
      ['184106358']
    end

    def images
      suborganization.organization.gallery_images +
        suborganization.gallery_images
    end
  end
end

