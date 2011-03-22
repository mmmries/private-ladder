class League
  include Mongoid::Document
  include Mongoid::Timestamps
  
  referenced_in :player, :inverse_of => :leagues
  
  field :name, :type => String
  field :description, :type => String
  
  ## score helper function
  def score=(score)
    @score = score
  end
  
  def score
    @score ||= 0
  end
  
  def get_players_in_point_order
    if @players_in_point_order.nil? then
      ##get a list of how many points each player has in this league
      tmp = Game.league_points_by_player(id)
      
      ##get a list of all the players in this league
      players = Player.any_of(:league_ids => id)
      
      ##match up points with players
      players = players.map do |p|
        p.score = tmp[p.id] unless tmp[p.id].nil?
        p
      end
      
      ##sort the players by reverse score
      @players_in_point_order = players.sort{ |p1, p2|  p2.score <=> p1.score }
    end
    @players_in_point_order
  end
  
  def get_recent_games(limit = 10)
    if @recent_games.nil? then
      @recent_games = Game.where(:league_id => id).desc(:created_at).limit(limit)
    end
    @recent_games
  end
end
