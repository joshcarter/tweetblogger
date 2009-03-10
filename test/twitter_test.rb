require 'test/unit'
require 'rubygems'
require 'mocha'
require 'twitter'

class TwitterTest < Test::Unit::TestCase
  def setup
    @config = Configuration::load('configuration.yml')
    @user = Twitter::User.new(@config[:twitter])
    @search = Twitter::Search.new(@config[:twitter])
  end
  
  # Mix of behavior testing and classic TDD
  def test_statuses
    HttpHelper.expects(:request).returns(canned_file(:timeline, :json))
  
    statuses = @user.timeline
  
    assert_equal "most recent tweet", statuses[0][:text]
    assert_equal "bar", statuses[1][:text]
    assert_equal "foo", statuses[2][:text]

    assert_equal Time, statuses[0][:created_at].class
  end
  
  def test_statuses_since
    HttpHelper.expects(:request).returns(canned_file(:timeline_since, :json))
  
    statuses = @user.timeline(:since_id => 707916062)
  
    assert_equal 3, statuses.length
  end
  
  def test_search
    HttpHelper.expects(:request).returns(canned_file(:search, :json))
    
    search = @search.search('#test')
    assert_equal 'kevinashworth', search[0][:user][:screen_name]
    assert_equal 'vtld', search[2][:user][:screen_name]
    
    assert_equal Time, search[0][:created_at].class
    assert search[0][:created_at] > search[1][:created_at]
  end
end
