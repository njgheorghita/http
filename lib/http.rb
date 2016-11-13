require 'socket'
require 'date'
require './lib/parser'
require './lib/generate'

class Http
  attr_reader   :tcp_server
  attr_accessor :counter,
                :current_game,
                :location

  def initialize
    @tcp_server    = TCPServer.new(9292)
    @counter       = 0
    @location      = nil
    @current_game  = nil
  end

  def server  
    loop do
      client = tcp_server.accept
      request_lines = []
      @counter += 1

      while line = client.gets and !line.chomp.empty?
        request_lines << line.chomp
      end

      incoming = Parser.new(request_lines).parsed_response
      data = Generate.new(incoming, client, current_game, counter)

      @current_game = data.current_game
      client.puts data.response

      puts ["This was displayed in your sexy browser:",data.response].join("\n")
      client.close

      break if incoming[:Path] == "/shutdown"
    end
  end
end

Http.new.server

