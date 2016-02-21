require 'rake'
require 'rspec/core/rake_task'

task :spec    => 'spec:all'
task :default => :test

task "build" do
  sh "docker build --rm --no-cache -f docker/ubuntu -t ubuntu:stns_test ."
  sh "docker build --rm --no-cache -f docker/rhel -t centos:stns_test ."
end

desc "all test"
task "test" => [:build]  do
  sh "docker run -t ubuntu:stns_test"
  sh "docker run -t centos:stns_test"
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
