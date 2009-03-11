#!/usr/bin/env ruby

require 'configuration'
require 'tweet_blogger'

config = Configuration::load(ARGV[0])
tweet_blogger = TweetBlogger.new(config)

tweet_blogger.post_tweets_to_blogger

if tweet_blogger.max_id
  config.twitter.since_id = tweet_blogger.max_id
  Configuration::save(config, ARGV[0])
end
