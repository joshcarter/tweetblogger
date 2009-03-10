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
      
      json = HttpHelper::request @config[:timeline_url].with_parameters(params), :auth => [@config[:username], @config[:password]]

      tweets = Array.new

      JSON::parse(json).each do |tweet|
        tweet = tweet.symbolize_keys
        tweet[:created_at] = Time.parse tweet[:created_at]
        
        tweets << tweet
      end
      
      return tweets
    end
  end
end
