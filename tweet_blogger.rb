require 'twitter'

class TweetBlogger
  def initialize(config)
    @config = config
    @blog = Blogger::Blog.new(config[:blogger])
    @user = Twitter::Base.new(config[:twitter][:username], config[:twitter][:password])
  end
  
  def twitter_activity
    since_id = @config[:twitter][:since_id]
    username = @config[:twitter][:username]
    
    if since_id
      user_timeline = @user.timeline(:user, :since_id => since_id)
      search = Twitter::Search.new('#' + username).since(since_id).fetch['results']
    else
      user_timeline = @user.timeline(:user)
      search = Twitter::Search.new('#' + username).fetch['results']
    end
    
    # Now merge them into one array
    user_timeline + search
  end
end
