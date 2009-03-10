require 'twitter'
require 'builder'

class TweetBlogger
  def initialize(config)
    @config = config
    @blog = Blogger::Blog.new(config.blogger)
    @user = Twitter::Base.new(config.twitter)
    @search = Twitter::Search.new(config.twitter)
  end
  
  def twitter_activity
    since_id = @config.twitter.since_id
    username = @config.twitter.username
    
    if since_id
      user_timeline = @user.timeline(:since_id => since_id)
      search = @search.search('#' + username).since(since_id).fetch['results']
    else
      user_timeline = @user.timeline(:user)
      # search = @search.search('#' + username, )  # TODO: HERE
    end
    
    # Now merge them into one array
    
    # TODO: sort by date here instead of ID
    
    all = user_timeline + search
    all.sort_by { |x,y| x.id.to_i <=> y.id.to_i }
  end
  
  def twitter_activity_formatted
    statuses = twitter_activity
    b = Builder::XmlMarkup.new(:indent => 2)
    
    xml = b.div(:class => 'tweet_blogger_post') do
      statuses.each do |status|
        
        # TODO: switch to common tweet format; change class based on screen_name
        
        case status.class.to_s
        when 'Twitter::Status'
          b.div(:class => 'user_status') do
            b.div(status.user.screen_name, :class => 'screen_name')
            b.div(status.text, :class => 'text')
            b.div(status.created_at, :class => 'created_at')
          end
        when 'Twitter::SearchResult'
          b.div(:class => 'search_result') do
            b.div(status.from_user, :class => 'screen_name')
            b.div(status.text, :class => 'text')
            b.div(status.created_at, :class => 'created_at')
          end
        end
      end
    end

    return xml
  end
end
