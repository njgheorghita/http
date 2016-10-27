require 'faraday'
require 'minitest/autorun'
require 'minitest/pride'

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

  def test_that_response_is_parsed_and_path_accurate     
    response = Faraday.get("http://127.0.0.1:9292/hello")
    assert response.body.include?("Hello, World!")
  end

  def test_that_post_to_start_game_starts_game   
    response = Faraday.post("http://127.0.0.1:9292/start_game")
    assert response.body.include?("Good Luck!")
  end

  def test_that_get_to_datetime_returns_datetime
    response = Faraday.get("http://127.0.0.1:9292/datetime")
    assert response.body.include?("2016")
  end

  def test_that_get_to_root_returns_response_message
    response = Faraday.get("http://127.0.0.1:9292/")
    assert response.body.include?("<html><head></head><body><pre>")
  end

  def test_that_get_to_wordsearch_returns_real_words
    response = Faraday.get("http://127.0.0.1:9292/word_search?word=stupidier")
    assert response.body.include?('stupidier is not a known word')
  end

  def test_that_get_to_wordsearch_returns_fake_words
    response = Faraday.get("http://127.0.0.1:9292/word_search?word=stupid")
    assert response.body.include?('stupid is a known word')
  end
    
end