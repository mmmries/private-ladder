# Load the rails application
require File.expand_path('../application', __FILE__)

#setup the DB connection
COUCHDB_DATABASE = CouchRest.new.database!('private-ladder')

# Initialize the rails application
Ladder::Application.initialize!
