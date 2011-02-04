class Game < CouchRest::Model::Base
  use_database DB
  
  timestamps!
  property :league, String
  property :participants, [Participant]
  
  def validate
    errors.add :participants, "a game must consist of at least 2 players" if participants.count < 2
  end
end
