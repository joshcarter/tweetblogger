require 'test/unit'
require 'rubygems'
require 'mocha'
require 'twitter'

class TwitterTest < Test::Unit::TestCase
  def setup
    @config = Configuration::load('configuration.yaml')
    @timeline = Twitter::Timeline.new(@config.twitter)
    @search = Twitter::Search.new(@config.twitter)
  end
  
  # Mix of behavior testing and classic TDD
  def test_tweets
    HttpHelper.expects(:request).returns(canned_file(:timeline, :json))
    String.any_instance.expects(:with_parameters).with(:count => 200).returns('foo')
  
    tweets = @timeline.timeline('bob')
  
    assert_equal "most recent tweet", tweets[0].text
    assert_equal "bar", tweets[1].text
    assert_equal "foo", tweets[2].text

    assert_equal Time, tweets[0].created_at.class
    assert_equal 1295336677, tweets[0].twitter_id
  end
  
  def test_tweets_since
    HttpHelper.expects(:request).returns(canned_file(:timeline_since, :json))
    String.any_instance.expects(:with_parameters).with(:count => 200, :since_id => 707916062).returns('foo')
  
    tweets = @timeline.timeline('bob', :since_id => 707916062)
  
    assert_equal 3, tweets.length
  end
  
  def test_tweets_since_with_no_results
    HttpHelper.stubs(:request).returns(canned_file(:timeline_no_results, :json))
  
    tweets = @timeline.timeline('bob')
    assert_equal Array, tweets.class
    assert_equal 0, tweets.length
  end
  
  def test_multiple_timelines
    HttpHelper.expects(:request).times(3).returns(canned_file(:timeline, :json))
  
    ['bob', 'fred', 'joe'].each do |screen_name|
      tweets = @timeline.timeline(screen_name)
    end
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

  def test_search_no_results
    HttpHelper.expects(:request).returns(canned_file(:search_no_results, :json))
    String.any_instance.expects(:with_parameters).with(:q => '#test').returns('foo')

    search = @search.search('#test')
    assert_equal Array, search.class
    assert_equal 0, search.length
  end
end
