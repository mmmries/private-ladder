class Game
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :league_id, :type => BSON::ObjectId
  embeds_many :participants
  
  def self.league_points_by_player(league_id)
    @@lpbp ||= {}
    if @@lpbp[league_id].nil? then
      map = <<MAP
        function(){
          for( var i in this.participants ) {
            var part = this.participants[i];
            emit(part.player._id, {points: part.points});
          }
        }
MAP

      reduce = <<REDUCE
        function(key, values){
          var total = 0;
          for( var i in values ) {
            var val = values[i];
            total += val.points;
          }
         return { points: total};
        }
REDUCE
    
      opts = { :out => {"inline" => true}, :raw => true, :query => {:league_id => league_id}}
    
      @@lpbp[league_id] = collection.map_reduce(map, reduce, opts)["results"]
    end
    @@lpbp[league_id]
  end
  
  def self.player_points_by_league(player_id)
    @@ppbl ||= {}
    if @@ppbl[player_id].nil? then
       map = <<MAP
        function(){
          for( var i in this.participants ) {
            var part = this.participants[i];
            emit(part.player._id, {points: part.points});
          }
        }
MAP

      reduce = <<REDUCE
        function(key, values){
          var total = 0;
          for( var i in values ) {
            var val = values[i];
            total += val.points;
          }
         return { points: total};
        }
REDUCE
    
      opts = { :out => {"inline" => true}, :raw => true, :query => {:league_id => league_id}}     
    end
    @ppbl[player_id]
  end
  
  def league
    @league ||= League.first(:conditions => {:id => league_id})
  end
  
  def validate
    errors.add :participants, "a game must consist of at least 2 players" if participants.count < 2
    errors.add :participants, "the game must have one winner" if participants.inject(0){ |sum, p| if p.result == "win" then sum + 1 else sum end } > 1
    player_ids = {}
    participants.each do |part|
      if player_ids[part.player.id].nil? then
        player_ids[part.player.id] = true
      else
        errors.add :participants, "player #{part.player.name} cannot be is in the game multiple times"
      end
    end
  end
end
