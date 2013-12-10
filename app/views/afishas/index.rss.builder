xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Афиша Томска от ЗнайГород"
    xml.description "Афиша Томска, все мероприятия и афиша города Томска - ЗнайГород"
    xml.link afisha_index_url

    for afisha in @presenter.decorated_collection
      xml.item do
        xml.title afisha.title
        xml.enclosure :url => resized_image_url(afisha.poster_url, 200, 269), :type => 'image/jpeg'
        xml.pubDate afisha.created_at.to_s(:rfc822)
        xml.link afisha_show_url(afisha)
      end
    end
  end
end
