require 'test/unit'
require 'rubygems'
require 'hpricot'
require 'httparty'
require 'mocha'
require 'twitter'

class TwitterTest < Test::Unit::TestCase
  def setup
    @user = Twitter::Base.new("foo", "foo")
  end

  def canned_file(filename, format = :xml)
    file = File::read("test/data/#{filename}.#{format}")
    
    case format
    when :xml  then Hpricot.XML(file)
    when :json then HTTParty::Parsers::JSON.decode(file)
    else file
    end
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
    @user.expects(:request).returns(canned_file(:timeline_since_small))

    statuses = @user.timeline(:user, :since_id => '707916062')

    assert_equal 3, statuses.length
  end
  
  def test_search
    Twitter::Search.expects(:get).returns(canned_file(:search, :json))
    
    search = Twitter::Search.new('#test').fetch
    assert_equal 'kevinashworth', search['results'][0].from_user
    assert_equal 'vtld', search['results'][2].from_user
  end
  
  def test_merge_statuses
    # get search results
    # get statuses
    # merge into one beast
  end
end
