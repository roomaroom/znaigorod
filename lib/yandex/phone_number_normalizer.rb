module Yandex
  class PhoneNumberNormalizer
    attr_accessor :phone_number

    def initialize(phone_number)
      @phone_number = phone_number
    end

    def normalize
      number = case phone_number.length
      when 6
        normalize_6_digits_phone_number
      when 10
        normalize_10_digits_phone_number
      when 11
        normalize_11_digits_phone_number
      end

      number ? "+#{default_country_code} #{number}" : nil
    end

    private

    def default_country_code
      '7'
    end

    def default_city_code
      '3822'
    end

    def normalize_6_digits_phone_number                                       # 223344 => (3822) 22-33-44
      fragments = phone_number.scan(/(\d{2})(\d{2})(\d{2})/).flatten

      "(#{default_city_code}) #{fragments.join('-')}"
    end

    def normalize_10_digits_phone_number
      case phone_number
      when /^382/                                                             # 3822445566 => (3822) 44-55-66
        fragments = phone_number.scan(/(\d{4})(\d{2})(\d{2})(\d{2})/).flatten
        city_code = fragments.shift

        "(#{city_code}) #{fragments.join('-')}"
      when /^9|^800/                                                          # 9234445566 => (923) 444-55-66, 8002003344 => (800) 200-33-44
        fragments = phone_number.scan(/(\d{3})(\d{3})(\d{2})(\d{2})/).flatten
        code = fragments.shift

        "(#{code}) #{fragments.join('-')}"
      end
    end

    def normalize_11_digits_phone_number
      @phone_number = phone_number[1..-1]

      normalize_10_digits_phone_number
    end
  end
end
