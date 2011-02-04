class PlayerStats < Hash
  include CouchRest::Model::CastedModel
  
  property :league, String
  
  #def validate
    #errors.add :total_games, "total games = wins + losses + draws" unless ( total_games == wins + losses + draws )
  #end
  
end
