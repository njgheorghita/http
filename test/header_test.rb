require 'minitest/autorun'
require 'minitest/pride'
require './lib/header'
require './lib/response'
require 'pry'

class HeaderTest < Minitest::Test

  def test_that_standard_header_is_built
    temp = Response.new({:Verb=>"GET", :Path=>"/hello", :Content_Length=>"44", :Protocol=>"HTTP/1.1", :Host=>"localhost", :Port=>"9292", :Origin=>"chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop", :Accept=>"*/*"},1)
    header = Header.new(temp, {:Verb => 'a',:Path => "b"},nil)
    assert_equal 138, header.header.length
  end

  def test_that_redirect_header_is_built
    temp = Response.new({:Verb=>"POST", :Path=>"/start_game", :Content_Length=>"44", :Protocol=>"HTTP/1.1", :Host=>"localhost", :Port=>"9292", :Origin=>"chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop", :Accept=>"*/*"},1)
    header = Header.new(temp, {:Verb => 'a',:Path => "b"}, "http://localserver:9292/game")
    redirect_header = [ "http/1.1 302 Redirecting","location: http://localserver:9292/game", "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}","server: ruby", "content-type: text/html; charset=iso-8859-1","content-length: 50\r\n\r\n"].join("\r\n")
    assert_equal 138, header.header.length
  end
end