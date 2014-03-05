# encoding: utf-8

desc "Generating feeds from another models"
task :get_sape_links => :environment do
  user = Settings['sape.user_id']
  host = Settings['app.url']

  # remote_ip dispencer-01.sape.ru
  remote_ip = '188.72.80.11'

  sape = Sape.new(:user => user,
                  :host => host,
                  :filename => Rails.root.join('sape', user, 'links.db'),
                  :remote_ip => remote_ip,
                  :uri => '')

  sape.update
end
