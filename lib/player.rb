class Player < CouchRest::Model::Base
  use_database DB
  
  property :name, String
  property :email, String
  property :password, String
  property :receive_notices, TrueClass, :default => true
  property :stats, [PlayerStats]
  timestamps!
  
  view_by :name
  view_by :score
  view_by :leagues, :map => "
    function(doc){
      if ( doc['couchrest-type'] == 'Player' && doc['stats'] ) {
        for( var i in doc['stats'] ) {
          emit( [doc['stats'][i]['league'], doc['name']], doc );
        }
      }
    }
  "
  
  validates_uniqueness_of :name
  
  
  ##custom functions
  def in_league?(lname)
    !Player.by_leagues(:key => [lname, name]).empty?
  end
end