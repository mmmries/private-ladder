get '/leagues' do
  haml :leagues, :locals => {:league_list => League.all}
end

get '/league/:uuid' do |uuid|
  l = League.find(uuid)
  ps = Player.by_leagues :key => l.name
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
  ps = PlayerStats.new(
    :total_games => 0,
    :wins => 0,
    :losses => 0,
    :draws => 0,
    :league => l.name
  )
  p.stats << ps
  p.save
  
  redirect '/leagues'
end

get '/leave' do
  p = session[:player]
  l = League.find(params[:lid])
  p.stats.delete_if do |st|
    st.league == l["name"]
  end
  p.save
  
  redirect '/leagues'
end
