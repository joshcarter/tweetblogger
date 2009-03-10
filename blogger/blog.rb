require 'http_helper'

module Blogger
  class Blog
    def initialize(config)
      @config = config
      @auth_token = nil
    end
    
    def login
      form_data = {
        'Email' => @config.username,
        'Passwd' => @config.password,
        'source' => 'joshcarter.com-blogger.rb-1.0',
        'service' => 'blogger'
      }
    
      response = HttpHelper::request(@config.login_url, :type => :post, :form_data => form_data)
      
      # One line will contain "Auth=...", we need to pull that out
      response.each_line do |line|
        key, val = line.split('=')
        if key == 'Auth'
          @auth_token = val
          return
        end
      end
      
      raise "No authorization token received"
    end
  
    def post(post)
      login if @auth_token == nil
      
      headers = {
        'Authorization' => "GoogleLogin auth=#{@auth_token}",
        'Content-Type' => 'application/atom+xml'
      }
      
      response = HttpHelper::request(@config.post_url, :type => :post, :body => post.atom_formatted, :headers => headers)
    end
  end
end
