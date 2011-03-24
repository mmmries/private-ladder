class Game
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :league_id, :type => BSON::ObjectId
  embeds_many :participants
  
  validate :validate_participants
  
  def validate_participants
    errors[:participants] << "a game must consist of at least 2 players" if participants.size < 2
    errors[:participants] << "the game must have one winner" if participants.inject(0){ |sum, p| if p.result == "win" then sum + 1 else sum end } != 1
    player_ids = {}
    participants.each do |part|
      errors[:participants] << "player #{part.player.name} cannot be in the game multiple times" unless player_ids[part.player.id].nil?
      player_ids[part.player.id] = true
    end
  end
  
  def self.league_points_by_player(league_id)
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

    opts = { :out => {"inline" => true}, :raw => true, :query => {:league_id => league_id} }
    tmp = collection.map_reduce(map, reduce, opts)["results"]
    hash = {}
    tmp.each do|t|
      hash[t["_id"]] = t["value"]["points"]
    end
    return hash
  end
  
  def self.player_points_by_league(player_id)
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
  end
  
  def league
    @league ||= League.first(:conditions => {:id => league_id})
  end
end
