require 'rspec/core'
require 'rspec/core/rake_task'

desc "Run those specs"
task :spec do

  RSpec::Core::RakeTask.new do |t|
    t.rspec_opts = %w{--colour --format progress}
    t.pattern = "./spec/**/*_spec.rb"
  end
end
