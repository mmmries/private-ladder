get '/leagues' do
  haml :leagues, :locals => {:league_list => League.all}
end

get '/league/:uuid' do |uuid|
  l = League.find(uuid)
  ps = l.get_players_in_point_order
  haml :league_homepage, :locals => {:league => l, :players => ps}
end

post '/league' do
  l = League.new(params)
  
  l.save
  redirect '/leagues'
end

get '/join' do
  p = session[:player]
  l = League.find(params[:lid])
  p.leagues << l["_id"]
  p.save
  
  redirect '/leagues'
end

get '/leave' do
  p = session[:player]
  l = League.find(params[:lid])
  p.leagues.delete_if do |st|
    st == l["_id"]
  end
  p.save
  
  redirect '/leagues'
end
