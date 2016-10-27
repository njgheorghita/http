class Parser
  attr_reader :request_lines
  def initialize(incoming)
    @request_lines = incoming
  end

  def first_line
    request_lines.find {|line| line.include?("POST") || line.include?("GET")}
  end

  def verb 
    first_line.split[0]
  end

  def path 
    arg = first_line.split[1]
  #refactor
    if arg.include?("?")
      params
    end
    arg.split("?")[0]
  end

  def content_length
    if request_lines.detect {|line| line.include?("Content-Length:")}
      request_lines.detect {|line| line.include?("Content-Length:")}.split[1]
    else nil
    end
  end
  
  def params
    key = first_line.split[1].split("?")[1].split("=")[0]
    value = first_line.split[1].split("?")[1].split("=")[1]
    {key: value}
  end

  def protocol 
    first_line.split[2]
  end

  def host_line
    request_lines.find {|line| line.include?("Host:")}.split[1]
  end
  
  def host 
    host_line.split(":")[0]
  end

  def port 
    host_line.split(":")[1]
  end

  def origin 
  #refactor
    unless request_lines.find {|line| line.include?("Origin:")} == nil
           request_lines.find {|line| line.include?("Origin:")}.split[1]
    end
  end

  def accept 
    request_lines.find {|line| line.include?("Accept:")}.split[1]
  end

  def parsed_response
    output = {}
        
    output[:Verb]           = verb
    output[:Path]           = path
    output[:Content_Length] = content_length unless content_length.nil?
    output[:Params]         = params if first_line.include?("?")
    output[:Protocol]       = protocol
    output[:Host]           = host
    output[:Port]           = port
    output[:Origin]         = origin
    output[:Accept]         = accept

    output
  end
end

class ParsePuts
  def initialize(input)
    @input = input
  end

  def output 
    chopped = @input.split("name=")[1].split("-")[0]
    chopped.scan(/\d/).join.to_i
  end
end

class HeaderBuild

  def initialize (output, status_code = 200, location = nil)
    @output = output
    @status_code = status_code
    @location = location
    @response_code = {
      200 => "ok", 
      301 => "Moved Permanently",
      302 => "Redirecting",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }
  end

  def header
    return_header = []
    return_header << "http/1.1 #{@status_code} #{@response_code[@status_code]}"
    return_header << "location: #{@location}" if !@location.nil?
    return_header << "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}"
    return_header << "server: ruby"
    return_header << "content-type: text/html; charset=iso-8859-1"
    return_header << "content-length: #{@output.length}\r\n\r\n"
    return_header.join("\r\n")
  end

end

