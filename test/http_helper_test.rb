require 'http_helper'

class HttpHelperTest < Test::Unit::TestCase
  def setup
    @url = 'http://foo.com/bar'
  end
  
  def test_url_with_parameters
    # No parameters should leave url unchanged
    assert_equal @url, @url.with_parameters(nil)
    assert_equal @url, @url.with_parameters(Hash.new)

    # One param
    assert_equal "#{@url}?foo=bar", 
                 @url.with_parameters(:foo => 'bar')

    # One param (bignum)
    assert_equal "#{@url}?foo=707916062", 
                @url.with_parameters(:foo => 707916062)

    # Two params
    assert_equal "#{@url}?baz=nob&foo=bar",
                 @url.with_parameters(:foo => 'bar', :baz => 'nob')

    # Params that require escaping
    assert_equal "#{@url}?baz=%25%25%26%26&foo=bar",
                 @url.with_parameters(:foo => 'bar', :baz => '%%&&')
  end

  def test_create_get_request
    Net::HTTP::Get.expects(:new)
    Net::HTTP.any_instance.expects(:start).returns(nil)
    HttpHelper::request @url, :type => :get
  end

  def test_create_post_request
    Net::HTTP::Post.expects(:new)
    Net::HTTP.any_instance.expects(:start).returns(nil)
    HttpHelper::request @url, :type => :post
  end

  def test_http_request
    Net::HTTP.any_instance.expects(:start).returns(nil)
    HttpHelper::request @url
  end

  def test_failed_http_start
    Net::HTTP.any_instance.expects(:start).raises("foo!")

    assert_raises RuntimeError do
      response = HttpHelper::request @url
    end
  end
end
