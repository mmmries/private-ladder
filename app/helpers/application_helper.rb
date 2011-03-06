module ApplicationHelper
  
  def get_login
    if @user_login.nil? then
      @user_login = Player.find(session[:login])
    end
    @user_login
  end
  
  def set_login(user_id)
    session[:login] = user_id
  end
  
  def is_admin?
    if get_login.nil? then
      return false
    end
    get_login.is_admin?
  end
  
  def add_game_path(league)
    "/games/new?game[league_id]=#{league["_id"]}"
  end
  
  def join_league_path(league)
    "/leagues/#{league["_id"]}/join"
  end
  
  def leave_league_path(league)
    "/leagues/#{league["_id"]}/leave"
  end
end
