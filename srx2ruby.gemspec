# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "srx2ruby"
  s.version     = "0.1.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Aleksander Pohl"]
  s.email       = ["apohllo@o2.pl"]
  s.homepage    = "http://github.com/apohllo/srx2ruby"
  s.summary     = %q{srx2ruby translates SRX files to Ruby.}
  s.description = %q{This project allows for generating Ruby class 
    providing sentence breaking capabilities based on given SRX file.}

  s.rubyforge_project = "srx2ruby"
  s.has_rdoc = false

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
