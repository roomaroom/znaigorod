class UrlToRecord
  attr_accessor :url

  def initialize(url)
    @url = url.squish
  end

  def record
    begin
      klass.try :find, id
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end

  private

  def klass
    case url
    when /\/afisha\/.+/
      Afisha
    when /\/organizations\/.+/
      Organization
    when /\/reviews\/.+/
      Review
    else
      nil
    end
  end

  def id
    case url
    when /\/afisha\/.+/
      url.match(/\/afisha\/(.+)/).try(:captures).try(:first)
    when /\/organizations\/.+/
      url.match(/\/organizations\/(.+)/).try(:captures).try(:first)
    when /\/reviews\/.+/
      url.match(/\/reviews\/(.+)/).try(:captures).try(:first)
    end
  end
end
