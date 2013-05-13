Gem::Specification.new do |s|
  s.name        = 'rover'
  s.version     = '1.1.2'
  s.date        = '2013-03-03'
  s.summary     = "dependency config orchestration"
  s.description = "discovery and installation of a project that uses npm +- bundler +- pip requirements"
  s.authors     = ["Mike Rosengarten"]
  s.email       = 'mfrosengarten@gmail.com'
  s.files       = ["lib/rover.rb"]
  s.homepage    =
    'http://rubygems.org/gems/rover'
  s.add_runtime_dependency 'colorize'
  s.add_runtime_dependency 'json'
  # s.add_runtime_dependency 'foreman'
  s.executables << 'rover'
end