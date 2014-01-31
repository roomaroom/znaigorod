require 'gilenson'
require 'redcloth'
require 'rexml/document'
require 'rinku'

AutoHtml.add_filter(:redcloth) do |text, options|
  attributes = Array(options).reject { |k,v| v.nil? }.map { |k, v| %{#{k}="#{REXML::Text::normalize(v)}"} }.join(' ')
  result = RedCloth.new(text).to_html
  result = Rinku.auto_link(result, :all, attributes)
  result = Gilenson.new(result.gsub('&#8220;', '"').gsub('&#8221;', '"')).to_html.html_safe

  result
end
