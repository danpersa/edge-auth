$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "edge-auth/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "edge-auth"
  s.version     = EdgeAuth::VERSION
  s.authors     = ["Dan Persa"]
  s.email       = ["dan.persa@gmail.com"]
  s.homepage    = "https://github.com/danpersa/edge-auth"
  s.summary     = "EdgeAuth is an authentication solution"
  s.description = "EdgeAuth is an authentication solution"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.0.0"

end
