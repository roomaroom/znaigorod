settings_yml_path = "config/settings.yml"
config = YAML::load(File.open(settings_yml_path))
raise "not found deploy key in settings.yml. see settings.yml.example" unless config['deploy']
application = config['deploy']["application"]
raise "not found deploy.application key in settings.yml. see settings.yml.example" unless application
domain = config['deploy']["domain"]
raise "not found deploy.domain key in settings.yml. see settings.yml.example" unless domain
port = config['deploy']["port"]
raise "not found deploy.port key in settings.yml. see settings.yml.example" unless port
pg_domain = config['deploy']["pg_domain"]
raise "not found deploy.pg_domain key in settings.yml. see settings.yml.example" unless pg_domain
pg_port = config['deploy']["pg_port"]
raise "not found deploy.pg_port key in settings.yml. see settings.yml.example" unless pg_port

set :application, application
set :domain, domain
set :port, port
set :pg_domain, pg_domain
set :pg_port, pg_port

set :rails_env, "production"
set :deploy_to, "/srv/#{application}"
set :use_sudo, false
set :unicorn_instance_name, "unicorn"

set :scm, :git
set :repository, "https://github.com/openteam-com/znaigorod.git"
set :branch, "master"
set :deploy_via, :remote_cache

set :keep_releases, 7

set :bundle_gemfile,  "Gemfile"
set :bundle_dir,      File.join(fetch(:shared_path), 'bundle')
set :bundle_flags,    "--deployment --quiet --binstubs"
set :bundle_without,  [:development, :test]

role :web, domain
role :app, domain
role :db,  domain, :primary => true
