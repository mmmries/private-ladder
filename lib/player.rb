class Player < CouchRest::Model::Base
  use_database DB
  
  property :name, String
  property :rank, Fixnum, :default => 0
  property :score, Float, :default => 0.0
  property :email, String
  property :receive_notices, TrueClass, :default => true
  property :stats, PlayerStats
  timestamps!
  
  view_by :name
  view_by :score
  
  validates_uniqueness_of :name
end