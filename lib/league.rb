class League < CouchRest::Model::Base
  use_database DB
  
  property :name, String
  property :description, String
  timestamps!
  
  view_by :name
end
