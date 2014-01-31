AutoHtml.add_filter(:away_links) do |html, options|
  fragment = Nokogiri::HTML.fragment(html.scrub)

  fragment.css('a').each do |a|
    next if a['href'] =~ /#{Settings['app.url']}/

    a['href']   = AwayLink.to(a['href'])
    a['target'] = '_blank'
    a['rel']    = 'nofollow'
  end

  fragment.to_html
end

