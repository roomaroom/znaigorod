def skip_url?(url)
  url =~ /#{Settings['app.url']}/ || url =~ /mailto:/
end

def real_url?(link_class)
  link_class =~ /real_url/
end

AutoHtml.add_filter(:external_links_attributes).with({}) do |html, options|
  fragment = Nokogiri::HTML.fragment(html.scrub)

  fragment.css('a').each do |a|
    next if skip_url?(a['href'])

    options.each { |attr, value| a[attr] = value }
  end

  fragment.to_html
end

AutoHtml.add_filter(:external_links_redirect) do |html, options|
  fragment = Nokogiri::HTML.fragment(html.scrub)

  fragment.css('a').each do |a|
    next if skip_url?(a['href'])
    next if real_url?(a['class'])

    a['href']   = AwayLink.to(a['href'])
  end

  fragment.to_html
end

AutoHtml.add_filter(:real_external_url) do |html, options|
  fragment = Nokogiri::HTML.fragment(html.scrub)

  fragment.css('a').each do |a|
    next unless real_url?(a['class'])

    a.delete('class')
    a['target'] = '_blank'
  end

  fragment.to_html
end
