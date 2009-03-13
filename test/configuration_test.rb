require 'configuration'

class ConfigTest < Test::Unit::TestCase
  def setup
    @config = Configuration::load('configuration.yaml')
  end
  
  def test_config_loaded
    assert_equal OpenStruct, @config.class
    assert_equal OpenStruct, @config.blogger.class
    assert_equal String, @config.blogger.login_url.class
    assert_equal Array, @config.twitter.timelines.class
    assert_equal String, @config.twitter.timelines[0].class
  end
  
  def test_load_bogus_config
    assert_raises RuntimeError do
      Configuration::load('no file by this name here')
    end
  end
end
