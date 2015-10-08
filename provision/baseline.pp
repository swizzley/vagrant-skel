# Configure the values for your forks
$deploy_puppet_private = ''
$deploy_puppet_public = ''
$deploy_hiera_private = ''
$deploy_hiera_public = ''
$id = ''

if ($deploy_puppet_private == '' or $deploy_puppet_public == '' or $deploy_hiera_private == '' or $deploy_hiera_public == '' or 
$ntid == '') {
  fail('use ssh-keygen from cli to create keys and then goto your forks in github and paste the public keys into the deploy keys tab of each relative fork and also paste the public and private keys in as variables in your vagrant provisioning fork, along with your NTid... Lines 2-7 of this file.'
  )
}
# Roles a.k.a. Purpose
case $::fqdn {
  /^gui.*/             : { $role = 'gui' }
  /^core.*/            : { $role = 'core' } 
  /^rmq.*/             : { $role = 'rabbitmq' }
  /^bp.*/              : { $role = 'app_bp' }
  /^hdp.*/             : { $role = 'hadoop' 
  default              : { $role = undef }
}
file { '/root/.ssh':
  ensure => 'directory',
  mode   => '0750',
  owner  => 'root',
  group  => 'root',
} ->
file { '/root/.ssh/id_rsa.puppet':
  ensure  => 'present',
  mode    => '0600',
  owner   => 'root',
  group   => 'root',
  content => $deploy_puppet_private,
} ->
file { '/root/.ssh/id_rsa.puppet.pub':
  ensure  => 'present',
  mode    => '0640',
  owner   => 'root',
  group   => 'root',
  content => $deploy_puppet_public,
} ->
file { '/root/.ssh/id_rsa.hiera':
  ensure  => 'present',
  mode    => '0600',
  owner   => 'root',
  group   => 'root',
  content => $deploy_hiera_private,
} ->
file { '/root/.ssh/id_rsa.hiera.pub':
  ensure  => 'present',
  mode    => '0640',
  owner   => 'root',
  group   => 'root',
  content => $deploy_hiera_public,
} ->
file { '/root/.ssh/config':
  ensure  => 'present',
  mode    => '0640',
  owner   => 'root',
  group   => 'root',
  content => '
Host            hiera
    Hostname        github.com
    IdentityFile    ~/.ssh/id_rsa.hiera
    IdentitiesOnly yes 

Host            puppet
    Hostname        github.com
    IdentityFile    ~/.ssh/id_rsa.puppet
    IdentitiesOnly yes ',
} ->
file { '/root/.ssh/known_hosts':
  ensure  => 'present',
  mode    => '0640',
  owner   => 'root',
  group   => 'root',
  content => 'github.com ssh-rsa AAAAB3NfaC1yc2EAAAADAQABAAABAQDuQcU9jkxOCGeZJm6s2FgZJ9NL4rRk7ZegFMY77mO0ihLFqom8S4OWoXPrW78XtGtfdB47c2CBD6ak1i/txWsMGnVMy2sMJOWouPbYd5FCuiXfiAZc5kbkUdI+B9JpI08qYhq3NuyfANG3d3xG76wjnibZyWnzrVpEKN5dw/o6cShuZ9Ew0UuCINyMANYtiAvt1U8M65R2hES1PHrp5szqUX5kOwurY/KHcTqVMRSASTrD3+HIE2NdRKbcy/qUTQJq3HwKbBFCLFeILbBdIEiIUcG1Abfx9NoPRauGG5u02QuCkVeo/e7IEKXuk9EzBuGRT2PiKv9vBhaE1FK7YhYh'
}

# Point yum to internal repos
file { [
  '/etc/yum.repos.d/CentOS-Base.repo',
  '/etc/yum.repos.d/CentOS-Debuginfo.repo',
  '/etc/yum.repos.d/CentOS-fasttrack.repo',
  '/etc/yum.repos.d/CentOS-Media.repo',
  '/etc/yum.repos.d/CentOS-Vault.repo',
  '/etc/yum.repos.d/epel.repo',
  '/etc/yum.repos.d/epel-testing.repo',
  '/etc/yum.repos.d/puppetlabs.repo']:
  ensure => absent
} -> exec { 'clean':
  command => '/usr/bin/yum clean all',
  unless  => '/usr/bin/test -f /etc/yum.repos.d/CENTOS-UPDATE.repo',
} ->
yumrepo { 'EPEL':
  descr    => 'Extra Packages for Enterprise Linux 6',
  baseurl  => 'http://yumrepo.example.net/epel/x86_64/6/',
  gpgcheck => '0',
  enabled  => '1',
} ->
yumrepo { 'PUPPET':
  descr    => 'Extra Packages for Enterprise Linux 6',
  baseurl  => 'http://yumrepo.example.net/puppetlabs/',
  gpgcheck => '0',
  enabled  => '1'
} ->
yumrepo { 'CENTOS-BASE':
  descr    => 'Extra Packages for Enterprise Linux 6',
  baseurl  => 'http://yumrepo.example.net/centos/x86_64/6/',
  gpgcheck => '0',
  enabled  => '1'
} ->
yumrepo { 'CENTOS-UPDATE':
  descr    => 'Extra Packages for Enterprise Linux 6',
  baseurl  => 'http://yumrepo.example.net/custom/centos/x86_64/6/centos6.6-x86_64-server-frozen/',
  gpgcheck => '0',
  enabled  => '1'
}

# Setup the code on the node
exec { 'clone_puppet':
  path    => '/usr/bin',
  command => "git clone git@puppet:${id}/Puppet.git /root/puppet",
  unless  => 'test -f /root/puppet/manifests/site.pp',
  require => File['/root/.ssh/known_hosts'],
} ->
file { '/etc/puppet/modules':
  ensure => link,
  force  => true,
  target => '/root/puppet/modules'
}

exec { 'clone_hiera':
  path    => '/usr/bin',
  command => "git clone git@hiera:${id}/Hiera.git /root/hiera",
  unless  => 'test -f /root/hiera/hiera.yaml',
  require => File['/root/.ssh/known_hosts'],
} ->
file { '/var/lib/hiera':
  ensure => link,
  force  => true,
  target => '/root/hiera'
} ->
file { '/etc/hiera.yaml':
  ensure => link,
  force  => true,
  target => '/root/hiera/hiera.yaml'
} ->
file { '/root/site.pp':
  ensure => link,
  target => '/root/puppet/manifests/site.pp'
} ->
file { '/var/lib/puppet/facts.d/scout.yaml':
  ensure => link,
  target => '/root/hiera/scout.yaml'
} ->
file { '/var/lib/puppet/facts.d/rabbitmq.yaml':
  ensure => link,
  target => '/root/hiera/rabbitmq.yaml'
} ->
file { "/var/lib/puppet/facts.d/${role}.yaml":
  ensure => link,
  target => "/root/hiera/vagrant/${role}.yaml"
} ->
file { '/etc/puppet/puppet.conf':
  ensure  => present,
  content => '
  [main]
  environment = vagrant
  factpath = /var/lib/puppet/facts.d
  
'
}

# git hooks

# implement
