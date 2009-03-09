require 'net/https'

module Blogger
  class Blog
    def initialize(params)
      @username = params[:username]
      @password = params[:password]
      @blog_id = params[:blogid]
      @login_url = URI::parse params[:login_url]
      @post_url = URI::parse params[:post_url]
      @auth_token = nil
    end
    
    def request(url, params = Hash.new)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = (url.scheme == 'https')
      response = nil
    
      http.start do |http|
        request = Net::HTTP::Post.new(url.path, params[:headers])
        request.form_data = params[:form_data] if params[:form_data]
        request.body = params[:body] if params[:body]
        response = http.request(request)
      end

      raise "Error #{response.code}: #{response.message}" unless response.is_a?(Net::HTTPSuccess)

      return response.body
    end
  
    def login
      form_data = {
        'Email' => @username,
        'Passwd' => @password,
        'source' => 'joshcarter.com-blogger.rb-1.0',
        'service' => 'blogger'
      }
    
      response = request(@login_url, :form_data => form_data)
      
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
      
      response = request(@post_url, :body => post.atom_formatted, :headers => headers)
    end
  end
end
