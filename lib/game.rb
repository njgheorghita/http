class Game
  attr_reader :guess_storage,
              :random_answer

  def initialize
    @guess_storage = []
    @random_answer = Random.new.rand(100)
  end

  def incoming_guess(guess)
    return if guess.nil?

    if !guess_storage.include?(guess)
      guess_storage << guess
    end

    if guess > 100
      "try guessing between 0 -> 100"
    elsif guess < random_answer
      "after #{guess_storage.count} guesses, your guess of #{guess} is too damn low"
    elsif guess > random_answer
      "after #{guess_storage.count} guesses, your guess of #{guess} is too damn high"
    elsif guess == random_answer
      "after #{guess_storage.count} guesses, your guess of #{guess} is on the dot"
    end
  end

end