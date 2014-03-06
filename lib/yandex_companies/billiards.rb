module YandexCompanies
  class Billiards < Xml
    def initialize
      @suborganizations = Billiard.all
    end
  end
end
