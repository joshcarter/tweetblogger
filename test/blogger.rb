require 'rubygems'
require 'mocha'
require 'blogger'

class TwitterTest < Test::Unit::TestCase
  def setup
    @config = YAML::load(File.read('config.yml'))
    @blog = Blogger::Blog.new(@config[:blogger])
  end
  
  def test_can_authenticate
    
    
    @blog.login
  end
end
