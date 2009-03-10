require 'test/unit'
require 'rubygems'
require 'mocha'
require 'twitter'

class TwitterTest < Test::Unit::TestCase
  def setup
    @config = Configuration::load('configuration.yml')
    @user = Twitter::User.new(@config.twitter)
    @search = Twitter::Search.new(@config.twitter)
  end
  
  # Mix of behavior testing and classic TDD
  def test_tweets
    HttpHelper.expects(:request).returns(canned_file(:timeline, :json))
    String.any_instance.expects(:with_parameters).with(:count => 200).returns('foo')
  
    tweets = @user.timeline
  
    assert_equal "most recent tweet", tweets[0].text
    assert_equal "bar", tweets[1].text
    assert_equal "foo", tweets[2].text

    assert_equal Time, tweets[0].created_at.class
  end
  
  def test_tweets_since
    HttpHelper.expects(:request).returns(canned_file(:timeline_since, :json))
    String.any_instance.expects(:with_parameters).with(:count => 200, :since_id => 707916062).returns('foo')
  
    tweets = @user.timeline(:since_id => 707916062)
  
    assert_equal 3, tweets.length
  end
  
  def test_search
    HttpHelper.expects(:request).returns(canned_file(:search, :json))
    String.any_instance.expects(:with_parameters).with(:q => '#test').returns('foo')
    
    search = @search.search('#test')
    assert_equal 'kevinashworth', search[0].user.screen_name
    assert_equal 'vtld', search[2].user.screen_name
    
    assert_equal Time, search[0].created_at.class
    assert search[0].created_at > search[1].created_at
  end

  def test_search_since
    HttpHelper.expects(:request).returns(canned_file(:search_since, :json))
    String.any_instance.expects(:with_parameters).with(:q => '#test', :since_id => 707916062).returns('foo')

    search = @search.search('#test', :since_id => 707916062)
    assert_equal 1, search.length
  end
end
