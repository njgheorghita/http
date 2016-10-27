require 'socket'
require 'date'
require './lib/parser'
require './lib/game'
require './lib/response'

tcp_server = TCPServer.new(9292)
counter = 0
current_game = nil

loop do
  client = tcp_server.accept
  counter += 1
  request_lines = []
  

  while line = client.gets and !line.chomp.empty?
    request_lines << line.chomp
  end

  parsed_incoming = Parser.new(request_lines).parsed_response
  
  body_data = client.read(parsed_incoming[:Content_Length].to_i)
  
  response_processing = Response.new(parsed_incoming, counter, current_game, body_data)
  response = response_processing.output
  current_game = response_processing.game_output

  if parsed_incoming[:Verb] == "GET"
    headers = HeaderBuild.new(response).header
  elsif parsed_incoming[:Verb] == "POST" && parsed_incoming[:Path] == "/start_game" && current_game.nil?
    headers = HeaderBuild.new(response, 301).header
  elsif parsed_incoming[:Verb] == "POST" && parsed_incoming[:Path] == "/start_game"
    headers = HeaderBuild.new(response, 301).header
  else 
    headers = HeaderBuild.new(response, 302, "http://localhost:9292/game").header
  end

  client.puts headers
  client.puts response

  puts ["This was displayed in your sexy browser:", response].join("\n")
  client.close

  if parsed_incoming[:Path] == "/shutdown"
    break
  end

end

if __FILE__ == 50
  Http.new.request
end