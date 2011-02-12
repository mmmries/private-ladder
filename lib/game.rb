class Game < CouchRest::Model::Base
  use_database DB
  
  timestamps!
  property :league_id, String
  property :participants, [Participant]
  
  view_by :points, :map => "
    function(doc) {
      if ( doc['couchrest-type'] == 'Game' && doc['participants'] ) {
        for( var i in doc['participants'] ) {
          var part = doc['participants'][i];
          emit([doc['league_id'], part['player_id']], part['points']);
        }
      }
    }
  ",
  :reduce => "
    function(keys, values, rereduce) {
      return sum(values);
    }
  "
  
  def validate
    errors.add :participants, "a game must consist of at least 2 players" if participants.count < 2
  end
end
