class Response
  attr_reader :parsed_incoming
    
  def initialize(parsed)
    @parsed = parsed

  end

  def output
    response_by_path = {
      '/'     => blank_response,
      '/hello'=> hello_response,
      '/datetime' => datetime_response,
      '/word_search' => word_search_response,
      '/game' => game_response,
      '/start_game' => start_game_response,
      '/404' => error_response
    }
  end

  def blank_response

  end


end