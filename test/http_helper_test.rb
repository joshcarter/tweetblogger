require 'http_helper'

class HttpHelperTest < Test::Unit::TestCase
  def setup
    @url = 'http://foo.com/bar'
  end
  
  def test_url_with_parameters
    # No parameters should leave url unchanged
    assert_equal @url, @url.with_parameters(nil)
    assert_equal @url, @url.with_parameters(Hash.new)

    # One param (string)
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

  # Classic TDD style
  def test_http_request_with_stub
    response = Net::HTTPOK.new('1.1', '200', 'OK')
    response.stubs(:body).returns('foo')
    Net::HTTP.any_instance.stubs(:request).returns(response)
    
    body = HttpHelper::request @url
    
    assert_equal 'foo', body
  end

  # Mock style
  def test_http_request_with_mock
    response = Net::HTTPOK.new('1.1', '200', 'OK')
    response.expects(:body)
    Net::HTTP.any_instance.expects(:request).returns(response)
    
    HttpHelper::request @url
  end

  def test_http_request_with_bad_response
    response = Net::HTTPInternalServerError.new('1.1', '500', 'Totally uncool')
    Net::HTTP.any_instance.expects(:request).returns(response)

    assert_raises RuntimeError do
      response = HttpHelper::request @url
    end
  end

  def test_create_get_request
    response = Net::HTTPOK.new('1.1', '200', 'OK')
    response.expects(:body)
    Net::HTTP::Get.expects(:new)
    Net::HTTP.any_instance.expects(:request).returns(response)

    HttpHelper::request @url, :type => :get
  end

  def test_create_post_request
    response = Net::HTTPOK.new('1.1', '200', 'OK')
    response.expects(:body)
    Net::HTTP::Post.expects(:new)
    Net::HTTP.any_instance.expects(:request).returns(response)

    HttpHelper::request @url, :type => :post
  end
end
