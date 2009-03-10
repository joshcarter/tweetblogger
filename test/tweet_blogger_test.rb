require 'rubygems'
require 'mocha'
require 'tweet_blogger'
require 'rexml/document'

class TweetBloggerTest < Test::Unit::TestCase
  def test_true
    assert true
  end
  
  # def setup
  #   @config = Configuration::load('configuration.yml')
  # end
  # 
  # def test_get_twitter_activity
  #   tweet_blogger = TweetBlogger.new(@config)
  # 
  #   Twitter::Base.any_instance.expects(:request).returns(canned_file(:timeline))
  #   Twitter::Search.expects(:get).returns(canned_file(:search, :json))
  # 
  #   statusus = tweet_blogger.twitter_activity
  #   assert_equal 39, statusus.length
  # end
  # 
  # def test_get_twitter_activity_since
  #   config = @config.dup
  #   config[:twitter][:since_id] = 123
  #   tweet_blogger = TweetBlogger.new(config)
  # 
  #   Twitter::Base.any_instance.expects(:request).returns(canned_file(:timeline_since))
  #   Twitter::Search.expects(:get).returns(canned_file(:search_since, :json))
  # 
  #   statuses = tweet_blogger.twitter_activity
  #   assert_equal 4, statuses.length
  # end
  # 
  # def test_tweet_activity_formatting
  #   tweet_blogger = TweetBlogger.new(@config)
  #   
  #   Twitter::Base.any_instance.expects(:request).returns(canned_file(:timeline))
  #   Twitter::Search.expects(:get).returns(canned_file(:search, :json))
  #   
  #   puts tweet_blogger.twitter_activity_formatted
  # end
  # 
  # def test_fetch_tweets_and_post_to_blog
  #   # @blog.expects(:login).returns(nil)
  #   # @blog.expects(:request).returns(canned_file('blogger_post', :txt))
  #   # @user.expects(:request).returns(canned_file(:timeline))
  # end
end
