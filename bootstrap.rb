require 'rubygems'
require 'sinatra'
require 'couchrest'
require 'couchrest_model'
require 'haml'
require 'sass'

APP_DIR = File.dirname(__FILE__)

## Load in all the configurations
Dir.glob(File.join([APP_DIR,'config','*'])).each do |config_file|
  load config_file
end

## Require all the libraries
Dir.glob(File.join([APP_DIR,'lib','*.rb'])).each do |lib_file|
  require lib_file
end
