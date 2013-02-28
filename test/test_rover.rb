require 'test/unit'
require 'rover'

class RoverTest < Test::Unit::TestCase
  def test_start_directory
    r = Rover.new
    assert_equal r.start_directory, Dir.pwd
  end

  def test_config_discovery
    configs = {"npm"=>"package.json","pip"=>"requirements.txt","bundle"=>"Gemfile"}
    r = Rover.new
    
    r.list_configs.each do |config_file_name,config_parts|
      assert configs.key?(config_parts['config_type'])
      assert_equal configs[config_parts['config_type']], config_parts['config_file']
    end
  end
end