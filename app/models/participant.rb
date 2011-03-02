class Participant < Hash
  include CouchRest::Model::CastedModel
  
  property :player_id, String
  property :result, String
  property :points, Float
  
  def validate
    errors.add :result, "result must be win, loss or draw" if ["win", "loss", "draw"].index(result).nil?
  end
  
end