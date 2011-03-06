class Game < CouchRest::Model::Base
  #select the database to be used
  use_database CouchServer.default_database
  
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
  
  def league
    @league ||= League.find(league_id)
  end
  
  def validate
    errors.add :participants, "a game must consist of at least 2 players" if participants.count < 2
    errors.add :participants, "the game must have one winner" if participants.inject(0){ |sum, p| if p.result == "win" then sum + 1 else sum end } > 1
  end
end
