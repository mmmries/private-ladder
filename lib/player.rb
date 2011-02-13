class Player < CouchRest::Model::Base
  use_database DB

  #note that this attribute is not a couchdb stored value, it is just for convenience  
  attr_accessor :score
  
  property :name, String
  property :email, String
  property :password, String
  property :receive_notices, TrueClass, :default => true
  property :leagues, [String]
  property :status, String, :default => "active"
  timestamps!
  
  view_by :name, :map => "
  function(doc){
    if ( doc['couchrest-type'] == 'Player' ) {
      if( !doc.status ) {
        doc.status = 'active';
      }
      if ( doc.status == 'active' ) {
        emit(doc.name, null);
      }
    }
  }
  "
  view_by :leagues, :map => "
  function(doc){
    if( !doc.status ) {
      doc.status = 'active';
    }
    if( doc['couchrest-type'] == 'Player' && doc['leagues'] && doc.status == 'active' ) {
      for( var i in doc['leagues'] ) {
        emit(doc['leagues'][i], doc);
      }
    }
  }
  "
  
  validates_uniqueness_of :name
  
  def validate
    errors.add :status, "a player must have a valid status" if ["active", "inactive"].index(status).nil?
  end
  
  
  ##custom functions
  def in_league?(league_id)
    !leagues.index(league_id).nil?
  end
end