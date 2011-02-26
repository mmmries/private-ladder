class Session < CouchRest::Model::Base
  #select the database to be used
  use_database CouchServer.default_database
  
  attr_accessor :username
  attr_accessor :password
end
