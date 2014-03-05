desc 'Generate xml files for Yandex'
task :generate_yandex_companies_xml_files => :environment do
  dir = Rails.root.join('public', 'yandex_xml')

  %w[saunas meals].each do |kind|
    klass = "yandex_companies/#{kind}".camelize.constantize

    File.open(dir.join("#{kind}.xml"), 'w') { |f| f.write klass.new.xml.to_xml  }
  end
end
