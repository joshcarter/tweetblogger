require 'rubygems'
require 'mocha'
require 'blogger'

class BloggerTest < Test::Unit::TestCase
  def setup
    @config = Configuration::load('configuration.yml')[:blogger]
    @blog = Blogger::Blog.new(@config)
  end
  
  def test_can_authenticate
    @blog.expects(:request).returns(canned_file('blogger_login', :txt))
    
    @blog.login
  end
  
  def test_failed_authenticate
    @blog.expects(:request).returns("foo!")
    
    assert_raises RuntimeError do
      @blog.login
    end
  end
  
  def test_failed_connection
    Net::HTTP.any_instance.expects(:start).raises("foo!")

    assert_raises RuntimeError do
      @blog.login
    end
  end
end
