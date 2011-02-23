class League < CouchRest::Model::Base
  #select the database to be used
  use_database CouchServer.default_database
  
  property :name, String
  property :description, String
end
