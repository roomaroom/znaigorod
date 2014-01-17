require 'gilenson'
require 'redcloth'
require 'rexml/document'
require 'rinku'

def add_attributes_to_links(html, options)
  fragment = Nokogiri::HTML.fragment(html.scrub)

  fragment.css('a').each do |a|
    unless a['href'] =~ /znaigorod.ru/
      a['target'] = options[:target] if options[:target].present?
      a['rel'] = options[:rel] if options[:rel].present?
    end
  end

  fragment.to_html
end

AutoHtml.add_filter(:redcloth).with({}) do |text, options|
  attributes = Array(options).reject { |k,v| v.nil? }.map { |k, v| %{#{k}="#{REXML::Text::normalize(v)}"} }.join(' ')
  result = RedCloth.new(text).to_html
  result = Rinku.auto_link(result, :all, attributes)
  result = add_attributes_to_links(result, options)
  result = Gilenson.new(result.gsub('&#8220;', '"').gsub('&#8221;', '"')).to_html.html_safe

  result
end
