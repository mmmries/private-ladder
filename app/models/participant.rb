class Participant < Hash
  include CouchRest::Model::CastedModel
  
  #note this is note a value stored in couchdb, it is a convenience function
  attr_accessor :player
  
  property :player_id, String
  property :result, String
  property :points, Float
  
  def validate
    errors.add :result, "result must be win, loss or draw" if ["win", "loss", "draw"].index(result).nil?
  end
  
  def player
    @player ||= Player.find(player_id)
  end
end