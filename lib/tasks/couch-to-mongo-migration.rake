namespace :db do
  desc "migrate all the data from couchdb into mongodb"
  task :emigrate => :environment do
    require 'couchrest'
    c = CouchRest::Server.new
    d = c.database("private-ladder")
    
    ##clear the mongoid db so that multiple migrations don't stack up
    Mongoid.master.collections.select do |collection|
      collection.name !~ /system/
    end.each(&:drop)
    
    ##migrate leagues
    leagues_res = d.view("League/all")
    leagues = {}
    m_leagues = {}
    leagues_res["rows"].each do |row|
      l = d.get(row["id"])
      leagues[row["id"]] = l
      h = JSON.parse(l.to_json)
      h.delete("_id")
      h.delete("_rev")
      h.delete("couchrest-type")
      m = League.new(h)
      m.save
      m_leagues[row["id"]] = m
    end
    
    ##migrate players
    players_res = d.view("Player/all")
    m_players = {}
    players_res["rows"].each do |row|
      p = d.get(row["id"])
      h = JSON.parse(p.to_json)
      h.delete("_id")
      h.delete("_rev")
      h.delete("couchrest-type")
      h.delete("stats")
      league_list = h["leagues"]
      h.delete("leagues")
      
      mp = Player.new(h)
      mp.league_ids = league_list.map{ |lid| m_leagues[lid].id }
      #puts "adding the following leagues to #{mp.name} - #{league_list.inspect}"
      mp.save
      m_players[row["id"]] = mp
    end
    
    ##migrate games/participants
    d.view("Game/all")["rows"].each do |row|
      g = d.get(row["id"])
      h = JSON.parse(g.to_json)
      h.delete("_id")
      h.delete("_rev")
      h.delete("couchrest-type")
      h.delete("participants")
      h.delete("league_id")
      h.delete("lid")
      
      ps = g["participants"].map do |part|
        pt = Participant.new
        pt.points = part["points"]
        pt.result = part["result"]
        pt.player = m_players[part["player_id"]]
        pt
      end
      
      mg = Game.new(h)
      mg.participants = ps
      mg.league_id = m_leagues[g["league_id"]].id
      mg.save
    end
  end
end
