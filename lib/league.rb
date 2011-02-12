class League < CouchRest::Model::Base
  use_database DB
  
  property :name, String
  property :description, String
  timestamps!
  
  view_by :name
  
  def get_players_in_point_order
    if @players_in_point_order.nil? then
      Game.by_points :key => {}
      tmp = DB.view('Game/by_points', :group_level => 2)
      @players_in_point_order = tmp["rows"].sort { |a,b| a["value"] <=> b["value"] }.reverse
    end
    @players_in_point_order
  end
end
