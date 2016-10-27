require_relative 'game'
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'

class GameTest < Minitest::Test

  def test_that_game_starts
    game = Game.new
    assert game
  end

  def test_that_game_returns_zero_guesses_made
    game = Game.new
    assert_equal 0, game.guess_count
  end

  def test_that_game_returns_guess_count_if_guess_is_made
    game = Game.new
    game.incoming_guess(33)
    assert_equal 1, game.guess_count
  end

  def test_that_game_recognizes_if_guess_made_outside_of_zero_to_hundred_range
    game = Game.new
    game.incoming_guess(101)
    assert_equal "try guessing between 0 -> 100", game.message
  end

end 