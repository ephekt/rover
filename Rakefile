require 'rake/testtask'

Rake::TestTask.new do |t|
	`rm -rf test/node_project/node_modules`
	t.libs << 'test'
end

desc "Run tests"
task :default => :test