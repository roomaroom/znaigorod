require 'openteam/capistrano/recipes'
require 'sidekiq/capistrano'

namespace :sitemap do
  desc 'Create symlinks to sitemap.xml and sitemap.xml.gz'
  task :symlinks, :except => { :no_release => true } do
    run "ln -nfs #{shared_path}/sitemaps/sitemap.xml #{deploy_to}/current/public/sitemap.xml"
    run "ln -nfs #{shared_path}/sitemaps/sitemap.xml.gz #{deploy_to}/current/public/sitemap.xml.gz"
  end
  after 'deploy:create_symlink', 'sitemap:symlinks'
end

set :default_stage, 'production'
