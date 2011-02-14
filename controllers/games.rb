get '/add-game' do
  l = League.find(params[:lid])
  haml :add_game, :locals => {:league_id => params[:lid], :players => Player.by_leagues(:key => l["_id"])}
end

post '/add-game' do
  g = Game.new(params)
  g.participants.each do |part|
    part.points = 1.0 if part.result == "win"
    part.points = -0.5 if part.result == "loss"
  end
  g.save
  redirect '/add-game?lid='+params[:league_id]
end
