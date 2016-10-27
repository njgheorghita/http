require 'faraday'
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'


############
############
###########
# clean up unnecessary faraday tests
# add more faraday tests that encapsulate games
# probably need faraday tests for status responses
# faraday test that get to /hello body response has hello world

class ServerTest < Minitest::Test
    attr_reader :url

    def setup
        @url = "http://127.0.0.1:9292/"
    end

    def test_that_host_is_instantiated
        
        response = Faraday.new(url)
        assert_equal "127.0.0.1", response.host
    end 

    def test_that_port_is_instantiated
        
        response = Faraday.new(url)
        assert_equal 9292, response.port
    end

    def test_that_response_is_parsed
        
        response = Faraday.get("http://127.0.0.1:9292/hello/")
        assert_equal "<html><head></head><body><pre></pre></body></html>", response.env.body
    end

    def test_that_post_data_is_received
        
        response = Faraday.post("http://127.0.0.1:9292/"), {:guess => 33}
        params = {:guess=>33}
        assert_equal params, response[1]
    end

    def test_that_post_to_start_game_starts_game
        
        response = Faraday.post("http://127.0.0.1:9292/start_game/")
        assert_equal "<html><head></head><body><pre>Good Luck!</pre></body></html>", response.body
    end

    def test_that_get_to_game_returns_no_game_if_no_post_to_start_game_has_happened
        respond = Faraday.get("http://127.0.0.1:9292/game/")
        assert_equal "<html><head></head><body><pre>plz start game</pre></body></html>", respond.body
    end

    def test_that_get_to_game_returns_blank_data_if_game_has_been_started_but_no_guesses_made
        Faraday.post "http://127.0.0.1:9292/start_game/"
        response = Faraday.get("http://127.0.0.1:9292/game/")
        assert_equal "<html><head></head><body><pre>0 guesses made</pre></body></html>", response.body
    end

    def test_that_get_to_game_returns_data_if_one_guess_has_been_made
        Faraday.post "http://127.0.0.1:9292/start_game/"
        Faraday.post "http://127.0.0.1:9292/game/", {:guess => 33}
        response = Faraday.get("http://127.0.0.1:9292/game")
        assert_equal "<html><head></head><body><pre>1 guesses made</pre></body></html>", response.body
    end
    
end