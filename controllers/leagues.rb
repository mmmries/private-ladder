get '/leagues' do
  haml :leagues, :locals => {:league_list => League.all}
end
