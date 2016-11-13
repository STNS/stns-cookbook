require 'rake'
require 'rspec/core/rake_task'
require 'erb'

def log_level
  ENV['DEBUG'] ? 'info' : 'error'
end

task :spec    => 'spec:all'
task :default => :test

desc "all test"
task "test" => :all_delete do
  begin
    %w(centos ubuntu).each do |o|
      %w(x86 i386).each do |a|
        content = ERB.new(open("docker/#{o}.erb").read).result(binding)
        open("docker/tmp/stns_#{o}_#{a}","w") {
          |f| f.write(content)
        }

        puts "="*20 + " start #{o}-#{a}" + "="*20
        sh "docker build --rm -q --no-cache -f docker/tmp/stns_#{o}_#{a} -t #{o}:#{a}-spec ."
        sh "docker run --privileged -d --name #{o}-#{a}-spec -t #{o}:#{a}-spec /bin/bash"
        sh "docker exec #{o}-#{a}-spec echo '' > /var/log/messages || true" if o == 'centos'
        sh "docker exec #{o}-#{a}-spec echo '' > /var/log/syslog || true" if o == 'ubuntu'

        %w(develop-test-v1 develop-test-v2 develop-test-v3).each do |e|
          puts "="*10 + " start #{o}-#{a} #{e}" + "="*10
          sh "docker exec #{o}-#{a}-spec chef-client -z -l #{log_level} -o 'recipe[stns::server],recipe[stns::client]' -E #{e} -c .chef/client.rb"
          sh "docker exec #{o}-#{a}-spec spec/bin/rake spec"
          puts "="*10 + " end #{o}-#{a} #{e}" + "="*10
        end
        sh "docker rm -f #{o}-#{a}-spec"

        puts "="*20 + " end #{o}-#{a}" + "="*20
      end
    end
  ensure
    Rake::Task['all_delete'].execute unless ENV['DEBUG']
  end
end

task :all_delete do
  %w(centos ubuntu).each do |o|
    %w(x86 i386).each do |a|
      sh "docker rm -f #{o}-#{a}-spec || true"
    end
  end
end

unless ENV['SERVER_SPEC']
  require 'rake-foodcritic'
  require 'rake-chef-syntax'
  namespace :chef do
      task :tests => [:foodcritic, :syntax_check]
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
