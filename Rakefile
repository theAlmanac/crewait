require 'rubygems'
require 'rake/gempackagetask'

spec = Gem::Specification.new do |s|
    s.platform  =   Gem::Platform::RUBY
    s.name      =   "crewait"
    s.version   =   "0.0.0"
    s.author    =   "The Almanac"
    s.email     =   "jonah@thealmanac.org"
    s.summary   =   "Fast SQL bulk-insertion using an ActiveRecord-like API"
    s.files     =   FileList['lib/**/*.rb', 'spec/*'].to_a
    # s.require_path  << 'lib/extensions'
    s.test_files = Dir.glob('spec/lib/*.rb')
    s.has_rdoc  =   true
    s.extra_rdoc_files  =   ["README"]
    s.add_dependency('activerecord', '>= 2.2.2')
    s.add_development_dependency('rspec')
    s.rubyforge_project = 'crewait'
end

Rake::GemPackageTask.new(spec) do |pkg|
    pkg.need_tar = true
end

task :default => "pkg/#{spec.name}-#{spec.version}.gem" do
    puts "generated latest version"
end
