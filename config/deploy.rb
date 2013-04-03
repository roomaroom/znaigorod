require 'openteam/capistrano/recipes'
require 'whenever/capistrano'
require 'delayed/recipes'

set :default_stage, 'production'

after 'deploy:restart', 'delayed_job:restart'
