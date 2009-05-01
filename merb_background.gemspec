# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{merb_background}
  s.version = "0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["maiha"]
  s.date = %q{2009-05-01}
  s.description = %q{A slice for the Merb framework that offers background tasks for DataMapper}
  s.email = %q{maiha@wota.jp}
  s.extra_rdoc_files = ["README", "LICENSE", "TODO"]
  s.files = ["LICENSE", "README", "Rakefile", "TODO", "lib/merb_background", "lib/merb_background/config.rb", "lib/merb_background/spectasks.rb", "lib/merb_background/job.rb", "lib/merb_background/job", "lib/merb_background/job/dm.rb", "lib/merb_background/job/ar2dm.rb", "lib/merb_background/job/ar.rb", "lib/merb_background/job/bonus_features.rb", "lib/merb_background/slicetasks.rb", "lib/merb_background/merbtasks.rb", "lib/merb_background.rb", "spec/merb_background_spec.rb", "spec/spec_helper.rb", "spec/requests", "spec/requests/main_spec.rb", "app/views", "app/views/layout", "app/views/layout/merb_background.html.erb", "app/views/main", "app/views/main/index.html.erb", "app/controllers", "app/controllers/main.rb", "app/controllers/application.rb", "app/helpers", "app/helpers/application_helper.rb", "public/stylesheets", "public/stylesheets/master.css", "public/javascripts", "public/javascripts/master.js", "stubs/app", "stubs/app/controllers", "stubs/app/controllers/main.rb", "stubs/app/controllers/application.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/maiha/merb_background}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{merb}
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{A slice for the Merb framework that offers background tasks for DataMapper}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<merb-slices>, [">= 1.0.11"])
    else
      s.add_dependency(%q<merb-slices>, [">= 1.0.11"])
    end
  else
    s.add_dependency(%q<merb-slices>, [">= 1.0.11"])
  end
end
