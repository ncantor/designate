$:.push File.expand_path("../lib", __FILE__)
require "designate/version"

Gem::Specification.new do |s|
  s.name          = "zerigo-designate"
  s.version       = Designate::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["James Miller", "Noah Cantor"]
  s.summary       = %q{Ruby gem wrapper for the Zerigo DNS API}
  s.description   = %q{Designate is a simple Ruby gem wrapper for the Zerigo DNS API v1.1 specification.}
  s.homepage      = "http://github.com/ncantor/designate"
  s.email         = ["bensie@gmail.com", "noah@forward.co.uk"]

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.has_rdoc = false
  s.add_dependency("rest-client", "= 1.6.7")
  s.add_depenency("capify-ec2", ">=1.2.4")
  s.add_dependency("crack", "= 0.3.1")
  s.add_development_dependency('shoulda')
end
