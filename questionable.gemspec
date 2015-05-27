$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "questionable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "questionable"
  s.version     = Questionable::VERSION
  s.authors     = ["Nick Urban"]
  s.email       = ["nick@nickurban.com"]
  s.homepage    = "https://github.com/bespokepost/questionable"
  s.summary     = "Rails engine that programatically generates surveys."
  s.description = "Makes it easy to add and edit forms programatically, " +
                  "specifying select, radio, checkbox, or string input, " + 
                  "and recordings users' answers. " + 
                  "Questions can be associated with specific objects or with string labels. " +
                  "A form template and controller are including for displaying questions and recording answers, " +
                  "and ActiveAdmin is supported for editing the questions and options on the back-end."


  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.11"
  s.add_dependency 'haml'
  s.add_dependency 'formtastic', '~> 2.0'
  s.add_dependency 'stringex'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency 'factory_girl_rails'
end
