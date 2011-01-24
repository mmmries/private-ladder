get '/' do
  haml :index
end

before do
  unless session[:login].nil?
    session[:player] = Player.find(session[:login])
  end
end
