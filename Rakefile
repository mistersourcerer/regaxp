require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "yard"

RSpec::Core::RakeTask.new(:spec)

YARD::Rake::YardocTask.new do |t|
 t.files   = ["lib/**/*.rb"]
 t.options = ["graph"]
end

task :default => :spec
