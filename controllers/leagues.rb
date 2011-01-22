get '/leagues' do
  haml :leagues, :locals => {:league_list => League.all}
end

post '/league' do
  l = League.new(params)
  
  l.save
  redirect '/leagues'
end
