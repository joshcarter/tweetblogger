require 'configuration'

class ConfigTest < Test::Unit::TestCase
  def setup
    @config = Configuration::load('configuration.yml')
  end
  
  def test_config_loaded
    assert_equal Hash, @config.class
    assert_equal Hash, @config[:blogger].class
    assert_equal String, @config[:blogger][:login_url].class
  end
  
  def test_url_with_parameters
    base_url = @config[:blogger][:login_url]
    
    assert_equal "#{base_url}?foo=bar", 
                 base_url.with_parameters(:foo => 'bar')
    assert_equal "#{base_url}?baz=nob&foo=bar",
                 base_url.with_parameters(:foo => 'bar', :baz => 'nob')
    assert_equal "#{base_url}?baz=%25%25%26%26&foo=bar",
                 base_url.with_parameters(:foo => 'bar', :baz => '%%&&')
  end
end
