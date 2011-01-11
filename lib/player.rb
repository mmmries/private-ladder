class Player < CouchRest::ExtendedDocument
  use_database DB
  
  property :name
  property :rank
  property :email
  property :receive_notices
  timestamps!
  
  view_by :name
  view_by :rank
  
end