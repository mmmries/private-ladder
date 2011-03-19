class Game
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :league_id, :type => BSON::ObjectId
  embeds_many :participants
  
  #view_by :player_points, :map => "
  #  function(doc) {
  #    if ( doc['couchrest-type'] == 'Game' && doc['participants'] ) {
  #      for( var i in doc['participants'] ) {
  #        var part = doc['participants'][i];
  #        emit([doc['league_id'], part['player_id'], doc['created_at']], part['points']);
  #      }
  #    }
  #  }
  #",
  #:reduce => "
  #  function(keys, values, rereduce) {
  #    return sum(values);
  #  }
  #"
  
  #view_by :league_points, :map => "
  #  function(doc) {
  #    if ( doc['couchrest-type'] == 'Game' && doc['participants'] ) {
  #      for( var i in doc['participants'] ) {
  #        var part = doc['participants'][i];
  #        emit([part['player_id'], doc['league_id'], doc['created_at']], part['points']);
  #      }
  #    }
  #  }
  #",
  #:reduce => "
  #  function(keys, values, rereduce) {
  #    return sum(values);
  #  }
  #"
  
  #view_by :league_date, :map => "
  #  function(doc) {
  #    if ( doc['couchrest-type'] == 'Game' ) {
  #      emit([doc['league_id'], doc['created_at']], true);
  #    }
  #  }
  #"
  
  def league
    @league ||= League.find(league_id)
  end
  
  def validate
    errors.add :participants, "a game must consist of at least 2 players" if participants.count < 2
    errors.add :participants, "the game must have one winner" if participants.inject(0){ |sum, p| if p.result == "win" then sum + 1 else sum end } > 1
  end
end
