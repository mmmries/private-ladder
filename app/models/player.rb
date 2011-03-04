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
end
