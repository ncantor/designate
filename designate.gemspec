Gem::Specification.new do |s|
  s.name = "designate"
  s.version = "0.0.1"
  s.authors = ["James Miller"]
  s.summary = %q{Ruby wrapper for the Zerigo DNS API}
  s.description = %q{Designate is a simple Ruby wrapper for the Zerigo DNS API v1.1 specification.}
  s.homepage = "http://github.com/bensie/designate"
  s.email = "bensie@gmail.com"
  s.files  = %w( README.rdoc Rakefile LICENSE ) + Dir.glob("lib/**/*") + Dir.glob("test/**/*")
  s.has_rdoc = false
  s.add_dependency("rest-client", "~> 1.6.0")
  s.add_dependency("crack", "~> 0.1")
  s.add_development_dependency('shoulda')
end
