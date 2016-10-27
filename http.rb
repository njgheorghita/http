require 'socket'
require 'date'
require 'pry'
require_relative 'dictionary'
require_relative 'parser'
require_relative 'game'
require_relative 'response'

tcp_server = TCPServer.new(9292)
counter = 0

loop do
  client = tcp_server.accept
  counter += 1
  request_lines = []

  while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
  end

    goodies = Parser.new(request_lines)
    binding.pry
    # response = Response.new(goodies).output
    data = client.read(goodies.content_length.to_i)
    cases = ['/', '/hello','/datetime','/shutdown','/word_search','/game','/start_game']
    # get to /game and there is no game?
    if !cases.include?(goodies.path)
        html_output = '404 Not Found'
    elsif goodies.verb == "GET"
        case goodies.path
        when '/'
            html_output = '#{goodies.parsed_response}'
        when '/hello'
            html_output = "Hello, World! #{counter}"
        when '/datetime'
            html_output = Time.new.strftime("%m %M %p %A %B %e %Y")
        when '/shutdown'
            html_output = "Total Requests #{counter}: Goodbye"
        when '/word_search'
            html_output = Dictionary.new.is_word?(goodies.params[:key])
        when '/game'
            if @current_game.nil?
                html_output = 'plz start game'
            elsif @current_game.guess_count == 0
                html_output = "you haven't made a guess yet boofus"
            else 
                html_output = "#{@current_game.message}"
            end
        end
    elsif goodies.verb == "POST"
        case goodies.path
        when '/start_game' 
            if @current_game.nil?
                html_output = "Good Luck!"
                @current_game = Game.new
            else    
                html_output = "403 Forbidden"
            end
        when '/game'
            guess = ParsePuts.new(data).output
            html_output = @current_game.incoming_guess(guess)
        end

    end
        
    output= "<html><head></head><body><pre>#{html_output}</pre></body></html>"
    # refactor / maybe move to new method
    if !cases.include?(goodies.path)
        headers = HeaderBuild.new(output, 404)
    elsif goodies.verb == "GET"
        headers = HeaderBuild.new(output).header
    elsif goodies.verb == "POST" && goodies.path == "/start_game" && @current_game.nil?
        headers = HeaderBuild.new(output, 301).header
    elsif goodies.verb == "POST" && goodies.path == "/start_game"
        headers = HeaderBuild.new(output, 403).header
    else 
        headers = HeaderBuild.new(output, 302, "http://localhost:9292/game").header
    end
    client.puts headers
    client.puts output

    puts ["This was displayed in your sexy browser:", html_output].join("\n")
    client.close

    if goodies.path == "/shutdown"
        break
    end

end

if __FILE__ == 50
    Http.new.request
end