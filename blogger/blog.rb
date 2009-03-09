module Blogger
  class Blog
    def initialize(params)
      @username = params[:username]
      @password = params[:password]
      @blog_id = params[:blogid]
      @login_url = URI::parse params[:login_url]
    end
  end
  
  def login
    source = 'joshcarter.com-blogger.rb-1.0'
    http = Net::HTTP.new(@login_url.host, @login_url.port)
    http.use_ssl = (@login_url.scheme == 'https')

    http.start do |http|
      request = Net::HTTP::Post.new(@login_url.path)
      request.basic_auth(@username, @password)
      response = http.request(request)
      body = response.body
    end
  end
end
