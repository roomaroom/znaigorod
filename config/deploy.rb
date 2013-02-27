require 'bundler/capistrano'
require 'rvm/capistrano'
require 'capistrano/ext/multistage'

require 'delayed/recipes'
load 'config/deploy/tag'

set :stages, %w(development production)
set :default_stage, 'production'
