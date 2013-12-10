xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Скидки, сертификаты и купоны, акции и распродажи Томска"
    xml.description "Скидки, сертификаты и купоны, акции и распродажи Томска"
    xml.link discounts_url

    for discount in @presenter.collection
      xml.item do
        xml.title discount.title
        xml.enclosure :url => resized_image_url(discount.poster_url, 220, 164), :type => 'image/jpeg'
        xml.pubDate discount.created_at.to_s(:rfc822)
        xml.link discount_url(discount)
      end
    end
  end
end
