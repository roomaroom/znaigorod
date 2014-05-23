xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Обзоры и блоги о жизни в Томске"
    xml.description "Обзоры и блоги о жизни в Томске"
    xml.link reviews_url

    for review in @presenter.decorated_collection
      xml.item do
        xml.title review.title
        xml.enclosure :url => review.annotation_image(200, 354), :type => 'image/jpeg'
        xml.pubDate review.created_at.to_s(:rfc822)
        xml.link review_url(review)
      end
    end
  end
end
