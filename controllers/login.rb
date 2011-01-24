get '/login' do
  haml :login
end

post '/login' do
  p = Player.by_name :key => params[:name]
  p = p.first
  if p["password"] == params[:password]
    session[:login] = p["_id"]
  end
  redirect '/'
end

get '/logout' do
  session[:login] = nil
  redirect '/'
end
