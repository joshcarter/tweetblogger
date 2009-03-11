require 'twitter'
require 'blogger'
require 'builder'

class TweetBlogger
  attr_reader :max_id
  
  def initialize(config)
    @config = config
    @blog = Blogger::Blog.new(config.blogger)
    @user = Twitter::User.new(config.twitter)
    @search = Twitter::Search.new(config.twitter)
    @max_id = nil
  end
  
  def twitter_activity
    since_id = @config.twitter.since_id
    username = @config.twitter.username

    params = since_id ? { :since_id => since_id } : nil
    
    timeline = @user.timeline(params)
    search = @search.search('#' + username, params)
    
    all = timeline + search
    all = all.sort { |x,y| x.created_at <=> y.created_at }
    @max_id = all.last.twitter_id unless all.empty?
    return all
  end
  
  def twitter_activity_formatted
    tweets = twitter_activity
    return nil if tweets.empty?
    
    b = Builder::XmlMarkup.new # (:indent => 2)
    
    xml = b.div(:xmlns => 'http://www.w3.org/1999/xhtml', :class => 'tweet_blogger_post') do
      tweets.each do |tweet|
        # Switch class of div based on whether or not our user 
        # posted the tweet
        css_class = case tweet.user.screen_name
        when @config.twitter.username then 'my_tweet'
        else 'other_tweet'
        end
        
        b.div(:class => css_class) do
          b.div(tweet.user.screen_name, :class => 'screen_name')
          b.div(tweet.text, :class => 'text')
          b.div(tweet.created_at.strftime("%I:%M"), :class => 'created_at')
        end
      end
    end

    return xml
  end
  
  def post_tweets_to_blogger
    activity = twitter_activity_formatted
    return if activity.nil?

    title = Time.now.strftime("%I:%M")
    post = Blogger::Post.new(title, activity)
    @blog.post post
  end
end
