get '/players' do
  haml :players, :locals => {:player_list => Player.all}
end

get '/player/:uuid' do |uuid|
  p = Player.find(uuid)
  haml :player_homepage, :locals => {:player => p}
end

get '/register' do
  haml :register
end

post '/player' do
  p = Player.new
  p.name= params[:name]
  p.password= params[:password]
  p.email= params[:email]
  p.receive_notices = params[:receives_notices]
  
  p.save
  redirect '/players'
end
