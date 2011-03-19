class Participant
  include Mongoid::Document
  
  embedded_in :game, :inverse_of => :participants
  
  embeds_one :player
  field :result, :type => String
  field :points, :type => Float
  
  def validate
    errors.add :result, "result must be win, loss or draw" if ["win", "loss", "draw"].index(result).nil?
  end
end