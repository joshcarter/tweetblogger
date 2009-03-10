require 'configuration'

class ConfigTest < Test::Unit::TestCase
  def setup
    @config = Configuration::load('configuration.yml')
  end
  
  def test_symbolize_keys
    assert_equal Hash.new(:foo => 'bar'), Hash.new('foo' => 'bar').symbolize_keys
  end
  
  def test_config_loaded
    assert_equal Hash, @config.class
    assert_equal Hash, @config[:blogger].class
    assert_equal String, @config[:blogger][:login_url].class
  end
end
