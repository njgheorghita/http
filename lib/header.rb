class Header
  attr_reader :output, 
              :current_game,
              :pathy, 
              :verb

  def initialize(response, parsed_incoming, current_game)
    @output       = response
    @current_game = current_game
    @verb         = parsed_incoming[:Verb]
    @pathy        = parsed_incoming[:Path]
  end

  def generate
    return header(404)  if !actual_paths.include?(pathy)
    return header(500)  if pathy == "/force_error"
    return header       if verb == "GET" 
    return header(301)  if verb == "POST" && pathy == "/start_game" && current_game.nil? 
    return header(403)  if verb == "POST" && pathy == "/start_game" && !current_game.nil?
    return header(302,'http://localhost:9292/game') if verb == "POST" && pathy == "/game"
  end

  def header(status_code = 200, location = nil)
    return_header = []
    return_header << "http/1.1 #{status_code} #{response_code[status_code]}"
    return_header << "location: #{location}" if !location.nil?
    return_header << "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}"
    return_header << "server: ruby"
    return_header << "content-type: text/html; charset=iso-8859-1"
    return_header << "content-length: #{output.output.length}\r\n\r\n"
    return_header.join("\r\n")
  end

  def response_code
    { 200 => "ok", 
      301 => "Moved Permanently",
      302 => "Redirecting",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"}
  end

  def actual_paths
    ['/start_game','/','/hello','/datetime','/shutdown','/word_search','/game','/start_game','/force_error']
  end

end
 