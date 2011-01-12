get '/' do
  redirect '/player'  
end

get '/player' do
  haml :players, :locals => {:player_list => Player.all}
end

post '/player' do
  p = Player.new
  p.name= params[:name]
  p.rank= 0
  p.email= params[:email]
  p.receive_notices = params[:receives_notices]
  
  p.save
  redirect '/player'
end
