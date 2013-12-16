def deploy_to
  Rails.root.join('../..')
end

desc 'Refresh sitemap'
task :refresh_sitemaps => :environment do
  if Rails.env.production?
    Kernel.system "gunzip -c #{deploy_to}/shared/sitemaps/sitemap.xml.gz > #{deploy_to}/shared/sitemaps/sitemap.xml"
    Kernel.system "ln -s -f #{deploy_to}/shared/sitemaps/sitemap.xml.gz #{deploy_to}/current/public/sitemap.xml.gz"
    Kernel.system "ln -s -f #{deploy_to}/shared/sitemaps/sitemap.xml #{deploy_to}/current/public/sitemap.xml"
  else
    puts 'Run this task on production server'
  end
end
