require 'rubygems'
require 'sinatra'
require 'haml'

set :sessions, true


load File.join([File.dirname(__FILE__), 'bootstrap.rb'])


set :views, File.join([APP_DIR, '/templates'])

## Load all the controllers -- only required for web interface
Dir.glob(File.join([APP_DIR,'controllers', '*'])).each do |controller_file|
  load controller_file
end