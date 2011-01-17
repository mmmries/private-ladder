get '/login' do
  haml :login
end

post '/login' do
  p = Player.by_name :key => params[:name]
  
  redirect '/'
end
