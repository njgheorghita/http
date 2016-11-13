require './lib/dictionary'
require './lib/game'
require './lib/parser'

class Response
  attr_reader   :parsed,
                :body_data,
                :counter
  attr_accessor :current_game

  def initialize(parsed, counter, current_game = nil, body_data = nil)
    @parsed       = parsed
    @body_data    = body_data
    @counter      = counter
    @current_game = current_game
  end

  def output
    return "<html><head></head><body><pre>#{error_response}</pre></body></html>" if !html_output_by_path.keys.include?(parsed[:Path])
    html_insert = html_output_by_path[parsed[:Path]].()
    return "<html><head></head><body><pre>#{html_insert}</pre></body></html>" if parsed[:Path] == '/' 
    "<html><head></head><body><pre>#{html_insert}</pre><h6>#{parsed}</h6></body></html>"
  end

  def html_output_by_path 
    { '/'             => method(:blank_response),
      '/hello'        => method(:hello_response),
      '/datetime'     => method(:datetime_response),
      '/shutdown'     => method(:shutdown_response),
      '/word_search'  => method(:word_search_response),
      '/game'         => method(:game_response),
      '/start_game'   => method(:start_game_response),
      '/404'          => method(:error_response),
      '/force_error'  => method(:force_error_response)}
  end

  def game_response
    return get_response  if parsed[:Verb] == "GET"
    return post_response if parsed[:Verb] == "POST"
  end

  def get_response
    if current_game.nil?
      'Plz start the game proper, ya bish.'
    elsif current_game.guess_storage == []
      "Make a guess."
    else 
      redirect_guess = current_game.guess_storage[-1]
      current_game.incoming_guess(redirect_guess)
    end
  end
  
  def post_response
    current_game.incoming_guess(Parser.new(body_data).parse_post)
  end

  def start_game_response
    if current_game.nil?
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
    "Hello, World! = #{counter}"
  end

  def datetime_response
    Time.new.strftime("%m:%M%p on %A, %B %e, %Y")
  end

  def shutdown_response
    "You have made #{counter} requests : Goodbye"
  end

  def word_search_response
    Dictionary.new.is_word?(parsed[:Params][:key])
  end

  def error_response
    "404 NOT FOUND"
  end

  def force_error_response
    Thread.current.backtrace.join("\n")
  end

end