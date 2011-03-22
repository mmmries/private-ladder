class UniqueParticipantsValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    object.errors[attribute] << "a game must consist of at least 2 players" if value.size < 2
    object.errors[attribute] << "the game must have one winner" if value.inject(0){ |sum, p| if p.result == "win" then sum + 1 else sum end } != 1
    player_ids = {}
    value.each do |part|
      object.errors[attribute] << "player #{part.player.name} cannot be in the game multiple times" unless player_ids[part.player.id].nil?
      player_ids[part.player.id] = true
    end
  end
end
