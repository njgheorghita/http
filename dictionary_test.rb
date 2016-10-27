require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require_relative 'dictionary'

class DictionaryTest < Minitest::Test

    def test_that_dictionary_is_loaded
        instance = Dictionary.new
        assert_equal 235886, instance.dictionary.count
    end

    def test_that_dictionary_recognizes_real_words
        instance = Dictionary.new
        assert_equal "hello is a known word", instance.is_word?("hello")
    end

    def test_that_dictionary_rejects_fake_words
        instance = Dictionary.new
        assert_equal "thisisnotarealword is not a known word", instance.is_word?("thisisnotarealword")
    end

end