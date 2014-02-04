def skip_url?(url)
  url =~ /#{Settings['app.url']}/ || url =~ /mailto:/
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

    a['href']   = AwayLink.to(a['href'])
  end

  fragment.to_html
end
