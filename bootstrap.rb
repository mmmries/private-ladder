require 'rubygems'
require 'couchrest'

APP_DIR = File.dirname(__FILE__)

## Require all the libraries
Dir.glob(File.join([APP_DIR,'lib','*.rb'])).each do |lib_file|
  require lib_file
end

## Load in all the configurations
Dir.glob(File.join([APP_DIR,'config','*'])).each do |config_file|
  load config_file
end

