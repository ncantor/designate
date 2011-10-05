Gem::Specification.new do |s|
  s.name = "designate"
  s.version = "0.0.3"
  s.authors = ["James Miller", "Noah Cantor"]
  s.summary = %q{Ruby gem wrapper for the Zerigo DNS API}
  s.description = %q{Designate is a simple Ruby gem wrapper for the Zerigo DNS API v1.1 specification.}
  s.homepage = "http://github.com/ncantor/designate"
  s.email = "noah@forward.co.uk"
  s.files  = %w( README.rdoc Rakefile LICENSE ) + ['lib/designate.rb'] + Dir.glob("lib/designate/*") + Dir.glob("test/**/*")
  s.has_rdoc = false
  s.add_dependency("rest-client", "~> 1.6.0")
  s.add_dependency("crack", "~> 0.1")
  s.add_development_dependency('shoulda')
end
