class Game
  attr_reader :guess_count, 
              :message

  def initialize
    @guess_count = 0
    @guess_storage = []
    @random_answer = Random.new.rand(100)
  end

  def incoming_guess(guess)
    @guess_count += 1
    @guess_storage << guess

    if guess > 100
      @message = "try guessing between 0 -> 100"
    elsif guess < @random_answer
      @message = "your guess of #{guess} is too low"
    elsif guess > @random_answer
      @message = "your guess of #{guess} is too high"
    elsif guess == @random_answer
      @message = "your guess of #{guess} is on the dot"
    end
  end
  
end