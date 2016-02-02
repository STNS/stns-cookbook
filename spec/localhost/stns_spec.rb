require 'spec_helper'
%w(
  stns
  rsyslog
).each do |s|
  %w(
    start
    restart
  ).each do |cmd|
    describe command("service #{s} #{cmd}") do
        its(:exit_status) { should eq 0 }
    end

    describe service(s) do
        it { should be_running }
    end
  end
end

describe command("service stns reload") do
    its(:exit_status) { should eq 0 }
end

describe service("stns") do
    it { should be_running }
end

[
  "getent passwd",
  "getent passwd pyama",
].each do |cmd|
  describe command(cmd) do
    its(:stdout) { should match /pyama:x:1001:1001:pyama:\/home\/pyama:\/bin\/bash/ }
  end
end

[
  "getent shadow",
  "getent shadow pyama"
].each do |cmd|
  describe command(cmd) do
    its(:stdout) { should match /pyama:!!:::::::/ }
  end
end

[
  "getent group",
  "getent group pgroup1"
].each do |cmd|
  describe command(cmd) do
    its(:stdout) { should match /pgroup1:x:1001:pyama/ }
  end
end

describe command("/usr/local/bin/ssh_stns_wrapper pyama") do
  its(:stdout) { should match /ssh-rsa xxxxxx/ }
end
