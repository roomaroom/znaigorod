def deploy_to
  Rails.root.join('../..')
end

desc 'Refresh sitemap'
task :refresh_sitemaps => :environment do
  if Rails.env.production?
    # Rake::Task['sitemap:refresh'].execute

    Kernel.system "gunzip -c #{deploy_to}/shared/sitemaps/sitemap1.xml.gz > #{deploy_to}/shared/sitemaps/sitemap1.xml"
    Kernel.system "ln -s -f #{deploy_to}/shared/sitemaps/sitemap1.xml.gz #{deploy_to}/current/public/sitemap.xml.gz"
    Kernel.system "ln -s -f #{deploy_to}/shared/sitemaps/sitemap1.xml #{deploy_to}/current/public/sitemap.xml"
  else
    puts 'Run this task on production server'
  end
end
