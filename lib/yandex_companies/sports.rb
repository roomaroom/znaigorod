module YandexCompanies
  class Sports < Xml
    def initialize
      @suborganizations = Sport.all
    end
  end
end
