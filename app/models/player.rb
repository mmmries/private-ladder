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
    !league_ids.index(league_id).nil?
  end
  
  def is_admin?
    !self["is_admin"].nil?
  end
  
  def hash
    @hash ||= Digest::MD5.hexdigest(self["email"].downcase.chomp)
  end
  
  ##score helper function
  def score=(score)
    @score = score
  end
  
  def score
    @score ||= 0
  end
  
  def get_leagues_in_point_order
    if @leagues_in_point_order.nil? then
      ##get a list of how many points this player has in each of their leagues
      tmp = Game.player_points_by_league(id)
      
      ##get a list of all the leagues this player is in
      league_list = League.any_in(:_id => league_ids)
      
      ##match up points with players
      league_list = league_list.map do |l|
        l.score = tmp[l.id] unless tmp[l.id].nil?
        l
      end
      
      ##sort the players by reverse score
      @leagues_in_point_order = league_list.sort{ |l1, l2|  l2.score <=> l1.score }
    end
    @leagues_in_point_order
  end
end
