require 'rake'
require 'rspec/core/rake_task'

task :spec    => 'spec:all'
task :default => :test

task "build" do
  %w(centos ubuntu).each do |o|
    %w(x86 i386).each do |a|
      sh "docker build --rm --no-cache -f docker/#{o}-#{a}  -t #{o}:#{a}-spec ."
    end
  end
end

desc "all test"
task "test" => [:build]  do
  %w(centos ubuntu).each do |o|
    %w(x86 i386).each do |a|
      sh "docker run -t #{o}:#{a}-spec"
    end
  end
end

namespace :spec do
  targets = []
  Dir.glob('./spec/*').each do |dir|
    next unless File.directory?(dir)
    target = File.basename(dir)
    target = "_#{target}" if target == "default"
    targets << target
  end

  task :all     => targets
  task :default => :all

  targets.each do |target|
    original_target = target == "_default" ? target[1..-1] : target
    desc "Run serverspec tests to #{original_target}"
    RSpec::Core::RakeTask.new(target.to_sym) do |t|
      ENV['TARGET_HOST'] = original_target
      t.pattern = "spec/#{original_target}/*_spec.rb"
    end
  end
end
