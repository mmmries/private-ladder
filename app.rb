require 'rubygems'
require 'sinatra'
require 'haml'

set :sessions, true

FileUtils.mkdir_p 'log' unless File.exists?('log')
log = File.new("log/sinatra.log", "a")
$stdout.reopen(log)
$stderr.reopen(log)


load File.join([File.dirname(__FILE__), 'bootstrap.rb'])


set :views, File.join([APP_DIR, '/templates'])

## Load all the controllers -- only required for web interface
Dir.glob(File.join([APP_DIR,'controllers', '*'])).each do |controller_file|
  load controller_file
end