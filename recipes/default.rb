case node['platform_family']
when "rhel", "fedora"
  shell = 'yum-repo.sh'
  repo_file = '/etc/yum.repos.d/stns.repo'
when 'debian', 'ubuntu'
  shell = 'apt-repo.sh'
  repo_file = '/etc/apt/sources.list.d/stns.list'
end

execute 'install_repo' do
  command "curl -fsSL #{node['stns']['repo']}/scripts/#{shell} | sh"
  not_if "test -e #{repo_file}"
end

if node.environment == "develop-test" && node['platform_family'] == "rhel"
  execute 'install_repo' do
    command <<-EOS
    sed -i 's/\$basearch/i386/' /etc/yum.repos.d/stns.repo
    EOS
    only_if "gcc -v 3>&2 2>&1 1>&3 | grep i386"
  end

  include_recipe 'stns::develop_test'
end
