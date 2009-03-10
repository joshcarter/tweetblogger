require 'rubygems'
require 'mocha'
require 'tweet_blogger'
require 'rexml/document'

class TweetBloggerTest < Test::Unit::TestCase
  def test_true
    assert true
  end
  
  def setup
    @config = Configuration::load('configuration.yml')
  end
  
  def make_tweets(n, user)
    tweets = Array.new
    
    n.times do |i|
      tweets << OpenStruct.new(
        :id => i,
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
  
  def test_tweet_activity_formatting
    tweet_blogger = TweetBlogger.new(@config)
    
    Twitter::User.any_instance.expects(:timeline).returns(make_tweets(10, @config.twitter.username))
    Twitter::Search.any_instance.expects(:search).returns(make_tweets(10, 'bob'))
    
    xml = tweet_blogger.twitter_activity_formatted
    doc = REXML::Document.new xml

    assert_equal  @config.twitter.username, doc.elements.to_a('div/div/div')[0].text
  end

  # def test_fetch_tweets_and_post_to_blog
  #   # @blog.expects(:login).returns(nil)
  #   # @blog.expects(:request).returns(canned_file('blogger_post', :txt))
  #   # @user.expects(:request).returns(canned_file(:timeline))
  # end
end
