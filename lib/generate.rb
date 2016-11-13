require './lib/response'
require './lib/header'

class Generate
  attr_reader   :incoming, 
                :client,
                :current_game,
                :counter

  attr_accessor :response,
                :header

  def initialize(incoming, client, current_game, counter)
    @incoming         = incoming
    @client           = client
    @current_game     = current_game
    @counter          = counter
    @response         = nil
    @header           = nil
    generate
  end

  def body_data
    client.read(incoming[:Content_Length].to_i)
  end

  def generate
    temp = Response.new(incoming, counter, current_game, body_data)
    @response = temp.output
    @header = Header.new(temp, incoming, current_game).generate
    update_game(temp.current_game)
  end

  def update_game(input)
    @current_game = input
  end

end