require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require_relative 'parser'

class ParserTest < Minitest::Test
    attr_reader :default_array
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
        assert_equal "0", parse.content_length
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
        assert_equal "chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop", parse.origin 
    end

    def test_that_accept_is_parsed
        parse = Parser.new(default_array)
        assert_equal "*/*", parse.accept 
    end

    def test_that_parsed_response_is_returned_as_hash
        parse = Parser.new(default_array)
        parsed_array = {:Verb=>"POST", :Parse=>"/hello", :Protocol=>"HTTP/1.1", :Host=>"localhost", :Port=>"9292", :Origin=>"chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop", :Accept=>"*/*"}
        assert_equal parsed_array, parse.parsed_response
    end

    def test_that_arguments_are_parsed
        #why is the instance necessary here?
        parse = Parser.new(@default_params_array)
        parsed_params = {:key=>"stupify"}
        assert_equal parsed_params, parse.params
    end

    def test_that_parse_puts_outputs_guess
        parse = ParsePuts.new("------WebKitFormBoundaryBtP1caTdGoqQYVzO\r\nContent-Disposition: form-data; name=\"guess\"\r\n\r\n33\r\n------WebKitFormBoundaryBtP1caTdGoqQYVzO--\r\n")
        assert_equal 33, parse.output
    end

    def test_that_standard_header_is_built
        header = HeaderBuild.new("<html><head></head><body><pre></pre></body></html>")
        standard_header = ["http/1.1 200 ok", "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}", "server: ruby", "content-type: text/html; charset=iso-8859-1", "content-length: 50\r\n\r\n"].join("\r\n")
        assert_equal standard_header, header.header
    end

    def test_that_redirect_header_is_built
        header = HeaderBuild.new("<html><head></head><body><pre></pre></body></html>", 302, "http://localserver:9292/game")
        redirect_header = [ "http/1.1 302 Redirecting","location: http://localserver:9292/game", "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}","server: ruby", "content-type: text/html; charset=iso-8859-1","content-length: 50\r\n\r\n"].join("\r\n")
        assert_equal redirect_header, header.header
    end
end