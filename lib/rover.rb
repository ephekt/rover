require 'logger'
require 'open3'
require 'colorize'

module Utils
	# Cross-platform way of finding an executable in the $PATH.
	#
	#   which('ruby') #=> /usr/bin/ruby
	def which(cmd)
		exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
		ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
		exts.each { |ext|
			exe = File.join(path, "#{cmd}#{ext}")
			return exe if File.executable? exe
		}
		end
		return nil
	end

end

module Logging
	# This is the magical bit that gets mixed into your classes
	def logger
		Logging.logger
	end

	# Global, memoized, lazy initialized instance of a logger
	def self.logger
		@logger ||= begin
			logger = Logger.new(STDOUT)
			logger.level = ENV['ROVER_VERBOSE'] ? Logger::INFO : Logger::FATAL

			logger
		end
	end
end

# Rover.new
# rover.list_configs #=> hash
# rover.install_configs #=> execute on hash above
# TODO rover.run
# TODO rover.update_from_git
# TODO rover.authors_from_git

class Rover
	include Logging
	include Utils

	attr_accessor :start_directory
	
	CONFIG_FILE_NAMES = {
		"npm" => 'package.json',
		'bundle' => 'Gemfile',
		'pip' => 'requirements.txt'
	}

	def initialize
		@start_directory = Dir.pwd

		puts "Rover is starting in #{@start_directory}"
	end

	def list_configs
		discover_config_files
	end

	def config_env config_type
		return nil unless config_type
		self.send("config_env_#{config_type}")
	end

	def config_env_npm
		unless which('npm')
			raise "you are fucked. go install npm"
		end
	end

	def config_env_bundle
		# nothing to do
		unless which('bundle')
			exec_cmd "gem install bundler"
			unless which('bundle')
				raise "you're fucked. go install bundler"
			end
		end
	end

	# TODO BROKEN
	def config_env_pip
		['virtualenv','pip'].each do |exe|
			unless which(exe)
				raise "you're fucked; missing #{exe}. please install first"
			end
		end

		python_dir = "#{@start_directory}/.python"
		exec_cmd "mkdir -p #{python_dir}"
		exec_cmd "virtualenv #{python_dir}"
		ENV['PATH'] = "#{python_dir}/bin:#{ENV['PATH']}"
		ENV['PYTHONPATH'] = ""
	end

	def install_configs
		discovered_config_files = discover_config_files

		if discovered_config_files.empty?
			logger.info "Rover did not find any configuration files in this project"
		else
			logger.info "Rover found the following configuration files:"
			
			puts "Rover found #{discovered_config_files.size} configuration files".underline
			puts "\n"

			discovered_config_files.each do |config_file_name,config_parts|
				puts "Installing Config: #{config_file_name}".colorize( :color => :white, :background => :blue )

				config_env(config_parts['config_type'])
				
				cmd = "#{config_parts['config_type']} "
				case config_parts['config_type']
				when 'pip'
					cmd += "install -r #{config_parts['config_file']}"
				when 'bundle'
					cmd += "install"
				when 'npm'
					cmd += "install"
				else
					logger.info "Unknown Config Type: #{config_parts['config_type']}"
					next
				end
					
				change_dir(config_parts['config_path'])
				exec_cmd(cmd)

				puts "\n\n"
			end

			puts "Finished attempting to install config files. Moving back to the starting directory".colorize( :color => :white, :background => :blue )

			change_dir(@start_directory)
		end
	end

	private

	def exec_cmd cmd
		puts cmd.colorize( :color => :red, :background => :white )
		system cmd
	end

	def change_dir path
		puts "cd #{path}".colorize( :color => :white, :background => :blue )
		Dir.chdir path
	end

	def discover_config_files path = @start_directory
		file_names_pattern = "{#{CONFIG_FILE_NAMES.values.join(',')}}"

		logger.info "/Rover looks for config files (#{file_names_pattern})"

		parts = [path,'**',file_names_pattern]

		resp = {}

		Dir.glob(parts.join('/')).each do |config_file|
			next if should_exclude?(config_file)

			resp[config_file] = {}

			file_parts = config_file.split('/')

			resp[config_file]['config_type'] = CONFIG_FILE_NAMES.key(file_parts.last)
			resp[config_file]['config_file'] = file_parts.pop
			resp[config_file]['config_path'] = file_parts.join('/')
		end

		resp
	end

	def should_exclude? config_file
		config_file.include? 'node_module'
	end
end