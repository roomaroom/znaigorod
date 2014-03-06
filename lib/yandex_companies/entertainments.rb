module YandexCompanies
  class Entertainments < Xml
    def initialize
      @suborganizations = Entertainment.all
    end
  end
end
