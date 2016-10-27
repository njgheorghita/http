class Dictionary   
  attr_reader :dictionary

  def initialize
    @dictionary = File.read("/usr/share/dict/words").split
  end

  def is_word?(lookup_word)
    return "#{lookup_word} is a known word" if dictionary.include?(lookup_word)
    "#{lookup_word} is not a known word" 
  end
  
end