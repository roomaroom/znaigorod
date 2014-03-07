desc 'Generate xml files for Yandex'
task :generate_yandex_companies_xml_files => :environment do
  file = Rails.root.join('public', 'yandex', 'integration', 'companies', 'companies.xml')

  File.open(file, 'w') { |f| f.write Yandex::Companies.new.xml  }
end
