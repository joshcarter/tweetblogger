require 'test/unit'
require 'rubygems'
require 'hpricot'
require 'httparty'
require 'mocha'
require 'twitter'

class TwitterTest < Test::Unit::TestCase
  def setup
    @config = Configuration::load('configuration.yml')[:twitter]
    @user = Twitter::Base.new(@config[:username], @config[:password])
  end

  # Mix of behavior testing and classic TDD
  def test_statuses
    @user.expects(:request).returns(canned_file(:timeline))

    statuses = @user.timeline(:user)

    assert_equal "most recent tweet", statuses[0].text
    assert_equal "bar", statuses[1].text
    assert_equal "foo", statuses[2].text
  end
  
  def test_statuses_since
    @user.expects(:request).returns(canned_file(:timeline_since))

    statuses = @user.timeline(:user, :since_id => '707916062')

    assert_equal 3, statuses.length
  end
  
  def test_search
    Twitter::Search.expects(:get).returns(canned_file(:search, :json))
    
    search = Twitter::Search.new('#test').fetch
    assert_equal 'kevinashworth', search['results'][0].from_user
    assert_equal 'vtld', search['results'][2].from_user
  end
end
