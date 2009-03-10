require 'configuration'

class ConfigTest < Test::Unit::TestCase
  def setup
    @config = Configuration::load('configuration.yml')
  end
  
  def test_config_loaded
    assert_equal OpenStruct, @config.class
    assert_equal OpenStruct, @config.blogger.class
    assert_equal String, @config.blogger.login_url.class
  end
end
