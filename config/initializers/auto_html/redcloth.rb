require 'gilenson'
require 'redcloth'
require 'rexml/document'
require 'rinku'

def set_away_links(text)
  fragment = Nokogiri::HTML.fragment(text.scrub)

  fragment.css('a').each do |a|
    next if a['href'] =~ /#{Settings['app.url']}/

    a['href']   = AwayLink.to(a['href'])
    a['target'] = '_blank'
    a['rel']    = 'nofollow'
  end

  fragment.to_html
end

AutoHtml.add_filter(:redcloth).with({}) do |text, options|
  attributes = Array(options).reject { |k,v| v.nil? }.map { |k, v| %{#{k}="#{REXML::Text::normalize(v)}"} }.join(' ')
  result = RedCloth.new(text).to_html
  result = Rinku.auto_link(result, :all, attributes)
  result = set_away_links(result)
  result = Gilenson.new(result.gsub('&#8220;', '"').gsub('&#8221;', '"')).to_html.html_safe

  result
end
