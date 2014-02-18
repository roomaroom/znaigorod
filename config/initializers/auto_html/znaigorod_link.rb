require 'rinku'
require 'rexml/document'

AutoHtml.add_filter(:znaigorod_link).with({}) do |text, options|
  attributes = Array(options).reject { |k,v| v.nil? }.map { |k, v| %{#{k}="#{REXML::Text::normalize(v)}"} }.join(' ')

  Rinku.auto_link(text, :all, attributes) do |url|
    if afisha_slug = url.match(Regexp.new("#{Settings[:app][:url]}/afisha/(\\S+)"))
      afisha = Afisha.published.find_by_slug(afisha_slug[1])
      afisha ? afisha.title : url
    elsif organization_slug = url.match(Regexp.new("#{Settings[:app][:url]}/organizations/(\\S+)"))
      organization = Organization.find_by_slug(organization_slug[1])
      organization ? organization.title : url
    elsif review_slug = url.match(Regexp.new("#{Settings[:app][:url]}/reviews/(\\S+)"))
      review = Review.find_by_slug(review_slug[1])
      review ? review.title : url
    else
      url
    end
  end
end
