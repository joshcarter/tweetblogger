require 'net/https'

module Blogger
  class Blog
    def initialize(params)
      @username = params[:username]
      @password = params[:password]
      @blog_id = params[:blogid]
      @login_url = URI::parse params[:login_url]
      @authtoken = nil
    end
    
    def request(url, form_data)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = (url.scheme == 'https')
      response = nil
    
      http.start do |http|
        request = Net::HTTP::Post.new(url.path)
        request.form_data = form_data
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
    
      response = request(@login_url, form_data)
      
      # One line will contain "Auth=...", we need to pull that out
      response.each_line do |line|
        key, val = line.split('=')
        if key == 'Auth'
          @authtoken = val
          return
        end
      end
      
      raise "No authorization token received"
    end
  end
end
