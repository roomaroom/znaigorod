desc 'Generate xml files for Yandex'
task :generate_yandex_companies_xml_files => :environment do
  file = Rails.root.join('public', 'yandex', 'companies', 'list.xml')

  File.open(file, 'w') { |f| f.write Yandex::Companies.new.xml  }
end
