get '/' do
  haml :index
end

before do
  puts session
end
