require 'rake/testtask'

desc "Build gem"
task :gemify do
	sh 'rm gem/*'
	sh 'gem build rover.gemspec'
	sh 'mv rover-*.gem gem/'
	puts "Completed"
end

desc "install gem" 
task :install do
	sh 'gem install gem/rover-*.gem'
end

Rake::TestTask.new do |t|
	Rake::Task["gemify"].invoke
	Rake::Task["install"].invoke
	`rm -rf test/node_project/node_modules`
	t.libs << 'test'
end

desc "Run tests"
task :default => :test