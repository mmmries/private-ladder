class PlayerStats < Hash
  include CouchRest::Model::CastedModel
  
  property :total_games, Fixnum, :default => 0
  property :wins, Fixnum, :default => 0
  property :losses, Fixnum, :default => 0
  property :draws, Fixnum, :default => 0
  property :league, String
  
  validates_numericality_of :total_games, :only_integer => true, :greater_than_or_equal_to => 0
  validates_numericality_of :wins, :only_integer => true, :greater_than_or_equal_to => 0
  validates_numericality_of :losses, :only_integer => true, :greater_than_or_equal_to => 0
  validates_numericality_of :draws, :only_integer => true, :greater_than_or_equal_to => 0
  
  def validate
    errors.add :total_games, "total games = wins + losses + draws" unless ( total_games == wins + losses + draws )
  end
  
end
