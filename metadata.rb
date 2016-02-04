name             'stns'
maintainer       'pyama'
maintainer_email 'wwww.kazu.com@gmail.com'
license          'MIT'
description      'Installs/Configures stns'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.0.1'

recipe 'stns', 'Installs and configures stns server and client'
recipe 'stns::server', 'install server'
recipe 'stns::client', 'install client'

%w(centos redhat fedora ubuntu debian).each { |os| supports os }
