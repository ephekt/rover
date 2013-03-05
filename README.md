#Rover

Rover discoveres dependency configuration files in your project.

###Supported Configuration Packages
+ Ruby projects using Bundler (Gemfile) 
 + http://gembundler.com/
+ Node projects using NPM (package.json)
 + http://package.json.nodejitsu.com/
+ Python projects using PIP (requiresment.txt)
 + http://www.pip-installer.org/en/latest/requirements.html
 + We should change requirements.txt to requirements.json?

###Installation
	gem install rover

###Requirements
+ Rover was tested on Ruby 1.9.3
+ Ruby Version Manager (RVM) makes it easy to install multiple versions of Ruby on your platform. See: https://rvm.io/rvm/basics/

####Example:

	cd ~/your_project
	rover install


web: ruby hi.rb