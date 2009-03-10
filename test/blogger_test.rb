require 'rubygems'
require 'mocha'
require 'blogger'
require 'rexml/document'

class BloggerTest < Test::Unit::TestCase
  def setup
    @config = Configuration::load('configuration.yml')
    @blog = Blogger::Blog.new(@config[:blogger])
    @post = Blogger::Post.new('title goes here', 'body goes here')
  end
  
  def test_atom_format
    # Create XML doc from ATOM-formatted post, dig through it
    doc = REXML::Document.new @post.atom_formatted
    assert_equal 'title goes here', doc.elements.to_a('entry/title')[0].text
    assert_equal 'body goes here',  doc.elements.to_a('entry/content/div')[0].text
  end
  
  def test_can_login
    HttpHelper.expects(:request).returns(canned_file('blogger_login', :txt))
    
    @blog.login
  end
  
  def test_failed_login
    HttpHelper.expects(:request).returns("foo!")
    
    assert_raises RuntimeError do
      @blog.login
    end
  end
  
  def test_post
    @blog.expects(:login).returns(nil)
    HttpHelper.expects(:request).returns(canned_file('blogger_post', :txt))

    @blog.post(@post)
  end
end
