require 'json'
require 'configuration'
require 'time'
require 'http_helper'

module Twitter
  class Search
    def initialize(config)
      @config = config
    end
    
    def search(query)
      json = HttpHelper::request @config[:search_url].with_parameters(:q => query)

      tweets = Array.new

      JSON::parse(json)['results'].each do |tweet|
        tweet = tweet.symbolize_keys
        # make search result look a little more like a normal tweet
        tweet[:user] = {
          :profile_image_url => tweet[:profile_image_url],
          :id => tweet[:from_user_id],
          :screen_name => tweet[:from_user],
          :name => tweet[:from_user]
        }
        tweet[:created_at] = Time.parse tweet[:created_at]
          
        tweets << tweet
      end
      
      return tweets
    end
  end
end
