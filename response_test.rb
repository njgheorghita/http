require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require_relative 'response'

class ResponseTest < Minitest::Test

  def test_that_response_is_initiated
    response = Response.new()
    assert response
  end

  def test_blank_response
    response = Response.new()
    assert_equal 'blank', response.blank_response
  end




end