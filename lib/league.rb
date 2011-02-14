class League < CouchRest::Model::Base
  use_database DB
  
  #note that this is not a value stored in couchdb, it is a convenience function
  attr_accessor :score
  
  property :name, String
  property :description, String
  timestamps!
  
  view_by :name
  
  def get_players_in_point_order
    if @players_in_point_order.nil? then
      Game.by_points :key => {}
      #puts "querying the by_points view with these aparams #{{:group_level => 2, :start_key => [self["_id"], nil], :end_key => [self["_id"], {}]}}"
      
      ##get a list of how many points each player has in this league
      tmp = DB.view('Game/by_points', :group_level => 2, :startkey => [self["_id"], nil], :endkey => [self["_id"], {}])
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
end
