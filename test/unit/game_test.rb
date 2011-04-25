require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test "game attributes not null" do
    game = Game.new
    assert game.invalid?
    assert
  end
end
