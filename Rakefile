require 'rake'
require 'rspec/core/rake_task'
require 'erb'

def log_level
  ENV['DEBUG'] ? 'info' : 'error'
end

def tty
  `uname -a | grep -i darwin`.empty? ? nil : '-it'
end

task :spec    => 'spec:all'
task :default => :test

support_os = %w(centos6 centos7 ubuntu16 ubuntu18)
desc "all test"
task :ci => support_os.map(&:to_sym) << :all_delete

support_os.each do |o|
  desc "#{o} test"
  task o do
    begin
      sh "docker rm -f stns-cookbook-#{o} || true"
      sh "docker build -q -f docker/Dockerfile.#{o} -t stns-cookbook-#{o} ."
      sh "docker run --privileged -v `pwd`/#{o}:/opt/#{o} -d --name stns-cookbook-#{o} -t stns-cookbook-#{o} /sbin/init"
      sh "docker exec #{tty} stns-cookbook-#{o} bash -l -c 'bundle update --bundler && bundle install --without syntax --path=/opt/#{o}/bundle --binstubs --jobs 4'"
      sh "docker exec #{tty} stns-cookbook-#{o} bash -l -c \"/opt/chef/embedded/bin/gem install bundler -N && chef-client -z -l #{log_level} -o 'recipe[stns::server],recipe[stns::client]' -c .chef/client.rb\""
      sh "docker exec #{tty} stns-cookbook-#{o} bash -l -c 'bin/rake spec'"
      sh "docker rm -f stns-cookbook-#{o}"
    ensure
      Rake::Task['all_delete'].execute unless ENV['DEBUG']
    end
  end
end

task :all_delete do
  %w(centos6 centos7 ubuntu16 ubuntu18).each do |o|
    sh "docker rm -f stns-cookbook-#{o} | true"
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
