require 'spec_helper'

%w(stns libnss_stns).each do |f|
  describe file("/etc/stns/#{f}.conf") do
    it { should be_mode(644) }
    it { should be_owned_by('root') }
    it { should be_grouped_into('root') }
  end
end

describe file("/etc/stns/libnss_stns.conf") do
  its(:content) { should match(/ssl_verify = true/) }
  its(:content) { should match(%r{wrapper_path = "/usr/local/bin/stns-query-wrapper"}) }
  its(:content) { should match(/request_timeout = 3/) }
end

files = if os[:family] == 'redhat'
  if i386?
    %w(
      /usr/lib/libnss_stns.so
      /lib/security/libpam_stns.so
      /usr/lib/libnss_stns.so.2
    )
  else
    %w(
      /usr/lib64/libnss_stns.so
      /lib64/security/libpam_stns.so
      /usr/lib64/libnss_stns.so.2
    )
  end
elsif ['debian', 'ubuntu'].include?(os[:family])
  if i386?
    %w(
      /usr/lib/i386-linux-gnu/libnss_stns.so
      /lib/i386-linux-gnu/security/libpam_stns.so
      /lib/i386-linux-gnu/libnss_stns.so.2
    )
  else
    %w(
      /usr/lib/x86_64-linux-gnu/libnss_stns.so
      /lib/x86_64-linux-gnu/security/libpam_stns.so
      /lib/x86_64-linux-gnu/libnss_stns.so.2
    )
  end
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
