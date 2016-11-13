class Parser
  attr_accessor :request_lines
  
  def initialize(incoming)
    @request_lines = incoming
  end

  def parsed_response
    output = {}
    output[:Verb]           = verb
    output[:Path]           = path
    output[:Content_Length] = content_length.split[1] unless content_length.nil?
    output[:Params]         = params if first_line.include?("?")
    output[:Protocol]       = protocol
    output[:Host]           = host
    output[:Port]           = port
    output[:Origin]         = origin.split[1] unless origin.nil?
    output[:Accept]         = accept
    output
  end

  def first_line
    request_lines.find {|line| line.include?("POST") || line.include?("GET")}
  end

  def verb 
    first_line.split[0]
  end

  def parse_post
    @request_lines.split("name=")[1].split("-")[0].scan(/\d/).join.to_i
  end

  def path 
    params if first_line.split[1].include?("?")
    first_line.split[1].split("?")[0]
  end

  def content_length
    request_lines.detect {|line| line.include?("Content-Length:")}
  end
  
  def params
    key   = first_line.split[1].split("?")[1].split("=")[0]
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
    request_lines.find {|line| line.include?("Origin:")}
  end

  def accept 
    request_lines.find {|line| line.include?("Accept:")}.split[1]
  end

end

