require 'minitest/autorun'
require 'minitest/pride'
require './lib/response'

class ResponseTest < Minitest::Test
  attr_reader :parsed_post_test
              :parsed_get_word_search

  def setup
    @parsed_post_test = { :Verb => "POST", 
                          :Path => "/hello", 
                          :Content_Length => "0", 
                          :Protocol => "HTTP/1.1", 
                          :Host => "localhost", 
                          :Port => "9292", 
                          :Origin => "chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop", 
                          :Accept => "*/*"}

    @parsed_get_word_search ={:Verb=>"GET",
                              :Path=>"/word_search",
                              :Params=>{:key=>"stupid"},
                              :Protocol=>"HTTP/1.1",
                              :Host=>"localhost",
                              :Port=>"9292",
                              :Origin=>nil,
                              :Accept=>"*/*"}
  end

  def test_that_response_is_initiated
    response = Response.new(parsed_post_test)
    assert response
  end

  # def test_blank_response
  #   response = Response.new(parsed_post_test)
  #   assert_equal 'blank', response.output
  # end

  def test_params
    response = Response.new(@parsed_get_word_search)
    assert_equal "<html><head></head><body><pre>stupid is a known word</pre></body></html>", response.output
  end

end