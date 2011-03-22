class Game
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :league_id, :type => BSON::ObjectId
  embeds_many :participants
  
  validates :participants, :unique_participants => true
  
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
      tmp = collection.map_reduce(map, reduce, opts)["results"]
      hash = {}
      tmp.each do|t|
        hash[t["_id"]] = t["value"]["points"]
      end
      @@lpbp[league_id] = hash
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
            if ( part.player._id == '#{player_id}') {
              emit(this.league_id, {points: part.points});
            }
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
    
      opts = { :out => {"inline" => true}, :raw => true, :query => {"participants.player._id" => player_id}}
      tmp = collection.map_reduce(map, reduce, opts)["results"]
      hash = {}
      tmp.each do|t|
        hash[t["_id"]] = t["value"]["points"]
      end
      @@ppbl[player_id] = hash
    end
    @@ppbl[player_id]
  end
  
  def league
    @league ||= League.first(:conditions => {:id => league_id})
  end
end
