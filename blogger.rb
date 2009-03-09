require 'blogger/blog'
require 'blogger/post'

module Blogger
  URLS = { :login => 'http://twitter.com/statuses/user_timeline.xml' }.freeze
  
  def self.url_for(what, params = nil)
    url = URLS[what]
    
    raise RuntimeError("no URL for #{what}") unless url
    
    if params
      params.each_value do { |x| x = CGI.escape x }
      
      url = url + '?' + params.map { |x| x.join('=') }.sort.join('&')
    end
    
    return url
  end
end