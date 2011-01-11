get '/' do
  haml :players, :locals => {:player_list => Player.all}
end
