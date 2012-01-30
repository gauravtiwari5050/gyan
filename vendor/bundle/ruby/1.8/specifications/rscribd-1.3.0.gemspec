# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rscribd}
  s.version = "1.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Tim Morgan}, %q{Jared Friedman}, %q{Mike Watts}]
  s.date = %q{2011-07-06}
  s.description = %q{The official Ruby gem for the Scribd API. Scribd is a document-sharing website allowing people to upload and view documents online.}
  s.email = %q{api@scribd.com}
  s.extra_rdoc_files = [%q{README}]
  s.files = [%q{README}]
  s.homepage = %q{http://www.scribd.com/developers}
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{rscribd}
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{Ruby client library for the Scribd API}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mime-types>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
    else
      s.add_dependency(%q<mime-types>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
    end
  else
    s.add_dependency(%q<mime-types>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
  end
end
