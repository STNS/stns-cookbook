require 'spec_helper'

%w(
  start
  restart
  reload
  checkconf
).each do |cmd|
  describe command("service stns #{cmd}") do
      its(:exit_status) { should eq 0 }
  end
end

describe service('stns') do
  it { should be_enabled }
  it { should be_running }
end

#
# Normal pattern
#
[
  "getent passwd",
  "getent passwd example1",
].each do |cmd|
  describe command(cmd) do
    its(:stdout) { should match /example1:x:1001:1001:example1:\/home\/example1:\/bin\/bash/ }
  end
end

[
  "getent shadow",
  "getent shadow example1"
].each do |cmd|
  describe command(cmd) do
    its(:stdout) { should match /example1:!!:::::::/ }
  end
end

[
  "getent group",
  "getent group test_group1"
].each do |cmd|
  describe command(cmd) do
    its(:stdout) { should match /test_group1:x:1001:example1/ }
  end
end

describe command("/usr/local/bin/stns-key-wrapper example1") do
  its(:stdout) { should match /ssh-rsa x/ }
end

#
# missing reuired parameter
#
[
  "getent passwd",
  "getent passwd example2",
].each do |cmd|
  describe command(cmd) do
    its(:stdout) { should_not match /example2/ }
  end
end

[
  "getent group",
  "getent group test_group2"
].each do |cmd|
  describe command(cmd) do
    its(:stdout) { should_not  match /test_group2/ }
  end
end

#
# minimam reuired parameter
#
[
  "getent passwd",
  "getent passwd example3",
].each do |cmd|
  describe command(cmd) do
    its(:stdout) { should match /example3:x:1003:1003::\/home\/example3:\/bin\/bash/ }
  end
end

[
  "getent group",
  "getent group test_group3"
].each do |cmd|
  describe command(cmd) do
    its(:stdout) { should match /test_group3:x:1003:/ }
  end
end

#
# merge key
#
[
  "getent passwd",
  "getent passwd example4",
].each do |cmd|
  describe command(cmd) do
    its(:stdout) { should match /example4:x:1004:1004::\/home\/example4:\/bin\/bash/ }
  end
end

describe command("/usr/local/bin/stns-key-wrapper example4") do
  its(:stdout) { should match /ssh-rsa x.*ssh-rsa y/m }
end

[
  "getent group",
  "getent group test_group4"
].each do |cmd|
  describe command(cmd) do
    its(:stdout) { should match /test_group4:x:1004:example1/ }
  end
end

#
# link to not exest
#
[
  "getent passwd",
  "getent passwd example5",
].each do |cmd|
  describe command(cmd) do
    its(:stdout) { should match /example5:x:1005:1005::\/home\/example5:\/bin\/bash/ }
  end
end

[
  "getent group",
  "getent group test_group5"
].each do |cmd|
  describe command(cmd) do
    its(:stdout) { should match /test_group5:x:1005:example5/ }
  end
end

