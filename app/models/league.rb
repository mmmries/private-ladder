class League < CouchRest::Model::Base
  #select the database to be used
  use_database CouchServer.default_database
  
  #note that this attribute is not a couchdb stored value, it is just for convenience  
  attr_accessor :score
  
  property :name, String
  property :description, String
  timestamps!
  
  view_by :name
  
  def get_players_in_point_order
    if @players_in_point_order.nil? then
      ##get a list of how many points each player has in this league
      tmp = Game.by_player_points :reduce => true, :group_level => 2, :startkey => [self["_id"], nil], :endkey => [self["_id"], {}]
      player_point_map = tmp["rows"].to_hash_values { |row|  row["key"].last }
      
      ##get a list of all the players in this league
      players = Player.by_leagues :key => self["_id"]
      
      ##match up points with players
      players.each do |p|
        if player_point_map[p["_id"]].nil? then
          p.score = 0
        else
          p.score = player_point_map[p["_id"]]["value"]
        end
      end
      
      ##sort the players by reverse score
      @players_in_point_order = players.sort{ |p1, p2|  p2.score <=> p1.score }
    end
    @players_in_point_order
  end
  
  def get_recent_games(limit = 10)
    if @recent_games.nil? then
      @recent_games = Game.by_player_points :startkey => [self["_id"], {}], :endkey => [self["_id"], nil], :limit => limit, :descending => true
      
      player_lookup = {}
      @recent_games.each do |game|
        game.participants.each do |participant|
          player_lookup[participant.player_id] ||= Player.find(participant.player_id)
          participant.player = player_lookup[participant.player_id]
        end
      end
    end
    @recent_games
  end
end
