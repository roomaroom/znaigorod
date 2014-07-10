class PromotionFinder
  attr_accessor :promotion_url, :splited_url, :url_array

  def initialize(url)
    @promotion_url = url
    @url_array = Array.new
    @url_array << @promotion_url
  end

  def promotion
    return promotion_by_direct_url if promotion_by_direct_url
    return smart_promotion if smart_promotion
    nil
  end

  private
  def split_url
    @splited_url = promotion_url.split('/')
    @splited_url = @splited_url.drop(1)
  end

  def splited_url_length
    splited_url.length
  end

  def create_array
    split_url

    while url_array.length < splited_url_length do
      url_array << url_array.last.gsub("/#{splited_url.pop}","")
    end
    url_array
  end

  def promotion_by_direct_url
    create_array
    @url_array.each do |url|
       @promotion_by_direct_url ||= Promotion.find_by_url(url)
       return @promotion_by_direct_url if @promotion_by_direct_url
    end
    nil
  end

  def smart_promotion
    @smart_promotion ||= begin
                           if Afisha.kind.values.map(&:pluralize).map { |value| "/#{value}" }.include?(@url_array[1])
                             Promotion.find_by_url("/afisha")
                           end

                           promotion = nil

                           { :meal => 'kafe_tomska', :sport => 'sports' }.each do |suborganization_kind, url|
                             condition = Values.instance.send(suborganization_kind).categories.map(&:from_russian_to_param).map {|value| "/#{value}"}.include?(@url_array.last)

                             promotion = Promotion.find_by_url("/#{url}") and break if condition
                           end

                           promotion
                         end
  end
end
