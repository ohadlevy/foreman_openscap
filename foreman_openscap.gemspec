require File.expand_path('../lib/foreman_openscap/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "foreman_openscap"
  s.version     = ForemanOpenscap::VERSION
  s.date        = Date.today.to_s
  s.authors     = ["Šimon Lukašík"]
  s.email       = ["slukasik@redhat.com"]
  s.homepage    = "https://github.com/OpenSCAP/foreman_openscap"
  s.summary     = "Foreman plug-in for displaying OpenSCAP audit reports"
  s.description = "Foreman plug-in for managing security compliance reports"
  s.license     = "GPL-3.0"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "deface"
  s.add_dependency "scaptimony"
  #s.add_development_dependency "sqlite3"
end
