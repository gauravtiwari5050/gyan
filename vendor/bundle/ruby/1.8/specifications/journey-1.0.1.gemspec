# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{journey}
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Aaron Patterson}]
  s.date = %q{2012-01-26}
  s.description = %q{Journey is a router.  It routes requests.}
  s.email = [%q{aaron@tenderlovemaking.com}]
  s.extra_rdoc_files = [%q{Manifest.txt}, %q{CHANGELOG.rdoc}, %q{README.rdoc}]
  s.files = [%q{Manifest.txt}, %q{CHANGELOG.rdoc}, %q{README.rdoc}]
  s.homepage = %q{http://github.com/tenderlove/journey}
  s.rdoc_options = [%q{--main}, %q{README.rdoc}]
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{journey}
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{Journey is a router}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<minitest>, ["~> 2.10"])
      s.add_development_dependency(%q<racc>, [">= 1.4.6"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.11"])
      s.add_development_dependency(%q<json>, [">= 0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.10"])
      s.add_development_dependency(%q<hoe>, ["~> 2.12"])
    else
      s.add_dependency(%q<minitest>, ["~> 2.10"])
      s.add_dependency(%q<racc>, [">= 1.4.6"])
      s.add_dependency(%q<rdoc>, ["~> 3.11"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<rdoc>, ["~> 3.10"])
      s.add_dependency(%q<hoe>, ["~> 2.12"])
    end
  else
    s.add_dependency(%q<minitest>, ["~> 2.10"])
    s.add_dependency(%q<racc>, [">= 1.4.6"])
    s.add_dependency(%q<rdoc>, ["~> 3.11"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<rdoc>, ["~> 3.10"])
    s.add_dependency(%q<hoe>, ["~> 2.12"])
  end
end
