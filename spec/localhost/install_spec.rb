require 'spec_helper'

%w(server client).each do |f|
  describe file("/etc/stns/#{f}/stns.conf") do
    it { should be_mode(644) }
    it { should be_owned_by('root') }
    it { should be_grouped_into('root') }
  end
end

files = if os[:family] == 'redhat'
  %w(
    /usr/lib64/libnss_stns.so
    /usr/lib64/libnss_stns.so.2
  )
elsif ['debian', 'ubuntu'].include?(os[:family])
  %w(
    /usr/lib/x86_64-linux-gnu/libnss_stns.so
    /usr/lib/x86_64-linux-gnu/libnss_stns.so.2
  )
end

files.each do |f|
  describe file(f) do
    it { should be_owned_by('root') }
    it { should be_grouped_into('root') }
  end
end

%w(
  start
  restart
).each do |cmd|
  describe command("service stns #{cmd}") do
      its(:exit_status) { should eq 0 }
  end
end

describe service('stns') do
  it { should be_enabled }
  it { should be_running }
end
