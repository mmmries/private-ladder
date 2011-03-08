require 'digest/md5'

class Player < CouchRest::Model::Base
  #select the database to be used
  use_database CouchServer.default_database
  
  #note that this attribute is not a couchdb stored value, it is just for convenience  
  attr_accessor :score
  
  property :name, String
  property :email, String
  property :password, String
  property :receive_notices, TrueClass, :default => true
  property :leagues, [String]
  property :status, String, :default => "active"
  timestamps!
  
  view_by :name, :map => "
  function(doc){
    if ( doc['couchrest-type'] == 'Player' ) {
      if( !doc.status ) {
        doc.status = 'active';
      }
      if ( doc.status == 'active' ) {
        emit(doc.name, null);
      }
    }
  }
  "
  view_by :leagues, :map => "
  function(doc){
    if( !doc.status ) {
      doc.status = 'active';
    }
    if( doc['couchrest-type'] == 'Player' && doc['leagues'] && doc.status == 'active' ) {
      for( var i in doc['leagues'] ) {
        emit(doc['leagues'][i], doc);
      }
    }
  }
  "
  
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
  
  def get_leagues_in_point_order
    if @leagues_in_point_order.nil? then
      ##get a list of how many points this player has in each of their leagues
      tmp = Game.by_league_points :reduce => true, :group_level => 2, :startkey => [self["_id"], nil], :endkey => [self["_id"], {}]
      league_point_map = tmp["rows"].to_hash_values { |row|  row["key"].last }
      
      ##get a list of all the leagues this player is in
      league_list = leagues.map{ |lid| League.find(lid) }
      
      ##match up points with players
      league_list.each do |l|
        if league_point_map[l["_id"]].nil? then
          l.score = 0
        else
          l.score = league_point_map[l["_id"]]["value"]
        end
      end
      
      ##sort the players by reverse score
      @leagues_in_point_order = league_list.sort{ |l1, l2|  l2.score <=> l1.score }
    end
    @leagues_in_point_order
  end
end
