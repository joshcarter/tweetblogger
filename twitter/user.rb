require 'rubygems'
require 'json'
require 'http_helper'
require 'configuration'
require 'time'

module Twitter
  class User
    def initialize(config)
      @config = config
    end

    def timeline(params = nil)
      params = Hash.new if params == nil
      params[:count] = 200 unless params[:count]
      
      json = HttpHelper::request @config.timeline_url.with_parameters(params), :auth => [@config.username, @config.password]

      tweets = Array.new

      JSON::parse(json).each do |tweet|
        # Change time to proper Time object
        tweet['created_at'] = Time.parse tweet['created_at']
        tweet['twitter_id'] = tweet['id']
        
        tweets << tweet.to_struct
      end
      
      return tweets
    end
  end
end
