require 'rubygems'
require 'mocha'
require 'tweet_blogger'
require 'rexml/document'

class TweetBloggerTest < Test::Unit::TestCase
  def test_true
    assert true
  end
  
  def setup
    @config = Configuration::load('configuration.yaml')
  end
  
  def make_tweets(n, user)
    tweets = Array.new
    
    n.times do |i|
      tweets << OpenStruct.new(
        :twitter_id => i + 1,
        :created_at => Time::gm(2000, 1, 1, 12, i),
        :text => "I am tweet #{i}",
        :user => OpenStruct.new(:screen_name => user)
      )
    end
    
    tweets
  end
  
  def test_get_twitter_activity
    tweet_blogger = TweetBlogger.new(@config)
  
    Twitter::User.any_instance.expects(:timeline).returns(make_tweets(10, @config.twitter.username))
    Twitter::Search.any_instance.expects(:search).returns(make_tweets(10, 'bob'))
  
    statusus = tweet_blogger.twitter_activity
    assert_equal 20, statusus.length
  end
  
  def test_twitter_activity_with_no_tweets
    tweet_blogger = TweetBlogger.new(@config)
  
    Twitter::User.any_instance.expects(:timeline).returns([])
    Twitter::Search.any_instance.expects(:search).returns([])
      
    statusus = tweet_blogger.twitter_activity
    assert_equal 0, statusus.length
  end
  
  def test_tweet_activity_formatting
    tweet_blogger = TweetBlogger.new(@config)
    
    Twitter::User.any_instance.expects(:timeline).returns(make_tweets(10, @config.twitter.username))
    Twitter::Search.any_instance.expects(:search).returns(make_tweets(10, 'bob'))
    
    xml = tweet_blogger.twitter_activity_formatted
    doc = REXML::Document.new xml

    assert_equal  @config.twitter.username, doc.elements.to_a('div/div/div')[0].text
  end

  def test_max_id_seen
    tweet_blogger = TweetBlogger.new(@config)
  
    Twitter::User.any_instance.expects(:timeline).returns(make_tweets(10, @config.twitter.username))
    Twitter::Search.any_instance.expects(:search).returns([])
  
    tweet_blogger.twitter_activity
    assert_equal 10, tweet_blogger.max_id
  end

  def test_no_formatted_stuff_if_no_tweets
    tweet_blogger = TweetBlogger.new(@config)
  
    Twitter::User.any_instance.expects(:timeline).returns([])
    Twitter::Search.any_instance.expects(:search).returns([])
      
    xml = tweet_blogger.twitter_activity_formatted
    assert_equal nil, xml
  end

  def test_fetch_tweets_and_post_to_blog
    Twitter::User.any_instance.expects(:timeline).returns(make_tweets(10, @config.twitter.username))
    Twitter::Search.any_instance.expects(:search).returns(make_tweets(10, 'bob'))
    Blogger::Blog.any_instance.expects(:post).returns(nil)
    
    TweetBlogger.new(@config).post_tweets_to_blogger
  end
  
  def test_no_post_if_no_tweets
    Twitter::User.any_instance.expects(:timeline).returns([])
    Twitter::Search.any_instance.expects(:search).returns([])
    Blogger::Blog.any_instance.expects(:post).never
    
    TweetBlogger.new(@config).post_tweets_to_blogger
  end
end
