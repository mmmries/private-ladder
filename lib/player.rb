class Player < CouchRest::Model::Base
  use_database DB
  
  property :name, String
  property :email, String
  property :password, String
  property :receive_notices, TrueClass, :default => true
  property :leagues, [String]
  timestamps!
  
  view_by :name
  view_by :leagues, :map => "
  function(doc){
    if( doc['couchrest-type'] == 'Player' && doc['leagues'] ) {
      for( var i in doc['leagues'] ) {
        emit(doc['leagues'][i], doc);
      }
    }
  }
  "
  
  validates_uniqueness_of :name
  
  
  ##custom functions
  def in_league?(league_id)
    !leagues.index(league_id).nil?
  end
end