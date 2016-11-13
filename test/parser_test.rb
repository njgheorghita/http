require 'minitest/autorun'
require 'minitest/pride'
require './lib/parser'
require './lib/header'

class ParserTest < Minitest::Test
  attr_reader :default_array,
              :default_params_array

  def setup
    @default_array = ["POST /hello HTTP/1.1",
                    "Host: localhost:9292",
                    "Connection: keep-alive",
                    "Content-Length: 0",
                    "Cache-Control: no-cache",
                    "Origin: chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop",
                    "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36",
                    "Postman-Token: 9e14e589-cf1c-a0f4-2496-70f878f71eb8",
                    "Accept: */*",
                    "Accept-Encoding: gzip, deflate",
                    "Accept-Language: en-US,en;q=0.8"]
    @default_params_array = ["POST /word_search?word=stupify HTTP/1.1",
                    "Host: localhost:9292",
                    "Connection: keep-alive",
                    "Content-Length: 0",
                    "Cache-Control: no-cache",
                    "Origin: chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop",
                    "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36",
                    "Postman-Token: 9e14e589-cf1c-a0f4-2496-70f878f71eb8",
                    "Accept: */*",
                    "Accept-Encoding: gzip, deflate",
                    "Accept-Language: en-US,en;q=0.8"]
  end

  def test_that_default_array_is_received
    parse = Parser.new(default_array)
    assert_equal default_array, parse.request_lines
  end

  def test_that_verb_is_parsed
    parse = Parser.new(default_array)
    assert_equal "POST", parse.verb
  end

  def test_that_path_is_parsed
    parse = Parser.new(default_array)
    assert_equal "/hello", parse.path
  end

  def test_that_content_length_is_parsed
    parse = Parser.new(default_array)
    assert_equal "0", parse.content_length.split[1]
  end

  def test_that_protocol_is_parsed
    parse = Parser.new(default_array)
    assert_equal "HTTP/1.1", parse.protocol
  end

  def test_that_host_is_parsed
    parse = Parser.new(default_array)
    assert_equal "localhost", parse.host
  end

  def test_that_port_is_parsed
    parse = Parser.new(default_array)
    assert_equal "9292", parse.port
  end

  def test_that_origin_is_parsed
    parse = Parser.new(default_array)
    assert_equal "chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop", parse.origin.split[1]
  end

  def test_that_accept_is_parsed
    parse = Parser.new(default_array)
    assert_equal "*/*", parse.accept 
  end

  def test_that_parsed_response_is_returned_as_hash
    parse = Parser.new(default_array)
    parsed_array = {:Verb=>"POST", 
                    :Path=>"/hello", 
                    :Content_Length=>"0", 
                    :Protocol=>"HTTP/1.1", 
                    :Host=>"localhost", 
                    :Port=>"9292", 
                    :Origin=>"chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop", 
                    :Accept=>"*/*"}
    assert_equal parsed_array, parse.parsed_response
  end

  def test_that_arguments_are_parsed
    parse = Parser.new(default_params_array)
    parsed_params = {:key=>"stupify"}
    assert_equal parsed_params, parse.params
  end

  def test_that_parse_post_outputs_guess
    parse = Parser.new("------WebKitFormBoundaryBtP1caTdGoqQYVzO\r\nContent-Disposition: form-data; name=\"guess\"\r\n\r\n33\r\n------WebKitFormBoundaryBtP1caTdGoqQYVzO--\r\n")
    assert_equal 33, parse.parse_post
  end

end