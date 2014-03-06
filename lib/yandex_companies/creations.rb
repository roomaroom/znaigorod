module YandexCompanies
  class Creations < Xml
    def initialize
      @suborganizations = Creation.all
    end
  end
end
