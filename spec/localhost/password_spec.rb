# user password authentication
describe command(sudo_auth("example6", "example6")) do
  its(:exit_status) { should eq 0 }
end

# sudo password authentication
describe command(sudo_auth("example7", "example")) do
  its(:exit_status) { should eq 0 }
end
