require './lib/dictionary'
require './lib/game'
require './lib/parser'

class Response
  attr_reader :parsed,
              :body_data,
              :html_output_by_path,
              :current_game,
              :counter
    
  def initialize(parsed, counter, current_game = nil, body_data = nil)
    @parsed = parsed
    @body_data = body_data
    @counter = counter
    @current_game = current_game
    @html_output_by_path = {
      '/'             => method(:blank_response),
      '/hello'        => method(:hello_response),
      '/datetime'     => method(:datetime_response),
      '/shutdown'     => method(:shutdown_response),
      '/word_search'  => method(:word_search_response),
      '/game'         => method(:game_response),
      '/start_game'   => method(:start_game_response),
      '/404'          => method(:error_response)
    }
  end

  def output
    html_insert = html_output_by_path[parsed[:Path]].()
    return "<html><head></head><body><pre>#{html_insert}</pre></body></html>"
  end

  def game_output
    @current_game
  end

  def game_response
    case parsed[:Verb]
    when "GET"  
      if @current_game.nil?
        'Please start the game properly, ya bish.'
      elsif @current_game.guess_storage == []
        "You haven't made a guess yet, ya bish."
      else 
        "#{current_game.message}"
      end
    when "POST"
      user_guess = ParsePuts.new(body_data).output
      @current_game.incoming_guess(user_guess)
    end
  end

  def start_game_response
    if @current_game.nil?
      @current_game = Game.new
      "Good Luck!"
    else
      "403 Forbidden"
    end 
  end

  def blank_response
    parsed
  end

  def hello_response
    "Hello, World! #{counter}"
  end

  def datetime_response
    Time.new.strftime("%m:%M%p on %A, %B %e, %Y")
  end

  # IMPLEMENT CLOSE SERVER LOGIC
  def shutdown_response
    "You have made #{counter} requests : Goodbye"
  end

  def word_search_response
    single_word_hash = parsed[:Params]
    Dictionary.new.is_word?(single_word_hash[:key])
  end

  # CREATE LOGIC TO GET HERE IF NO PATH
  def error_response
    "404 NOT FOUND"
  end


end