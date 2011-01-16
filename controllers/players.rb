get '/players' do
  p request
  haml :players, :locals => {:player_list => Player.all}
end

get '/player' do
  haml :player_homepage
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
  redirect '/'
end
