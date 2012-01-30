# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{delayed_job_active_record}
  s.version = "0.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Matt Griffin}, %q{Brian Ryckbost}]
  s.date = %q{2012-01-01}
  s.description = %q{ActiveRecord backend for DelayedJob, originally authored by Tobias Luetke}
  s.email = [%q{matt@griffinonline.org}]
  s.extra_rdoc_files = [%q{README.md}]
  s.files = [%q{README.md}]
  s.homepage = %q{http://github.com/collectiveidea/delayed_job_active_record}
  s.rdoc_options = [%q{--main}, %q{README.md}, %q{--inline-source}, %q{--line-numbers}]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{ActiveRecord backend for DelayedJob}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, ["> 2.1.0"])
      s.add_runtime_dependency(%q<delayed_job>, ["~> 3.0.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.0"])
      s.add_development_dependency(%q<rake>, ["~> 0.8"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
    else
      s.add_dependency(%q<activerecord>, ["> 2.1.0"])
      s.add_dependency(%q<delayed_job>, ["~> 3.0.0"])
      s.add_dependency(%q<rspec>, ["~> 2.0"])
      s.add_dependency(%q<rake>, ["~> 0.8"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
    end
  else
    s.add_dependency(%q<activerecord>, ["> 2.1.0"])
    s.add_dependency(%q<delayed_job>, ["~> 3.0.0"])
    s.add_dependency(%q<rspec>, ["~> 2.0"])
    s.add_dependency(%q<rake>, ["~> 0.8"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
  end
end
