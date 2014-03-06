module YandexCompanies
  class Cultures < Xml
    def initialize
      @suborganizations = Culture.all
    end
  end
end
