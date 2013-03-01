require 'test/unit'
require 'rover'
require 'open-uri'
require 'open3'

class RoverTest < Test::Unit::TestCase
  def setup
    @rover = Rover.new
    @pids = []
  end

  def teardown
    @pids.each do |kill_pid|
      `kill -9 #{kill_pid}`
    end
  end

  def test_start_directory
    assert_equal @rover.start_directory, Dir.pwd
  end

  def test_config_discovery
    configs = {"npm"=>"package.json","pip"=>"requirements.txt","bundle"=>"Gemfile"}
    
    @rover.list_configs.each do |config_file_name,config_parts|
      assert configs.key?(config_parts['config_type'])
      assert_equal configs[config_parts['config_type']], config_parts['config_file']
    end
  end

  def test_install_configs
    @rover.install_configs
  end

  def test_procfile_for_ruby
    return true
    assert_equal false, @rover.run_servers
    pids = @rover.run_servers('test/ruby_project')
    pids.each {|p| @pids << p }
    assert_equal false, pids.empty?

    assert_equal "Hello World!", open('http://localhost:4567').read
  end
end