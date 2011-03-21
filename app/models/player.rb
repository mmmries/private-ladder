require 'digest/md5'

class Player
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, :type => String
  field :email, :type => String
  field :password, :type => String
  field :receive_notices, :type => Boolean, :default => true
  field :status, :type => String, :default => "active"
  field :is_admin, :type => Boolean, :default => false
  field :league_ids, :type => Array, :default => []
  
  validates_uniqueness_of :name
  
  def validate
    errors.add :status, "a player must have a valid status" if ["active", "inactive"].index(status).nil?
  end
  
  
  ##custom functions
  def in_league?(league_id)
    !leagues.index(league_id).nil?
  end
  
  def get_league_list
    if @league_list.nil? then
      @league_list = leagues.map do |lid|
        l = League.find(lid)
        tmp = DB.view('Game/by_points', :key => [lid, self["_id"]])
        if tmp["rows"].count == 1 then
          l.score = tmp["rows"].first["value"]
        else
          l.score = 0
        end
        l
      end
    end
    @league_list
  end
  
  def is_admin?
    !self["is_admin"].nil?
  end
  
  def hash
    @hash ||= Digest::MD5.hexdigest(self["email"].downcase.chomp)
  end
  
  def gravatar_img( size = 40 )
    "<img src='http://www.gravatar.com/avatar/#{hash}?s=#{size}' class='gravatar' />"
  end
  
  def score=(score)
    @score = score
  end
  
  def score
    @score ||= 0
  end
  
  #def get_leagues_in_point_order
  #  if @leagues_in_point_order.nil? then
  #    ##get a list of how many points this player has in each of their leagues
  #    tmp = Game.by_league_points :reduce => true, :group_level => 2, :startkey => [self["_id"], nil], :endkey => [self["_id"], {}]
  #    league_point_map = tmp["rows"].to_hash_values { |row|  row["key"].last }
  #    
  #    ##get a list of all the leagues this player is in
  #    league_list = leagues.map{ |lid| League.find(lid) }
  #    
  #    ##match up points with players
  #    league_list.each do |l|
  #      if league_point_map[l["_id"]].nil? then
  #        l.score = 0
  #      else
  #        l.score = league_point_map[l["_id"]]["value"]
  #      end
  #    end
  #    
  #    ##sort the players by reverse score
  #    @leagues_in_point_order = league_list.sort{ |l1, l2|  l2.score <=> l1.score }
  #  end
  #  @leagues_in_point_order
  #end
end
