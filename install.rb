system('wget https://packages.chef.io/files/stable/chef/12.17.44/el/7/chef-12.17.44-1.el7.x86_64.rpm')
system('yum localinstall chef-12.17.44-1.el7.x86_64.rpm')
system('rm chef-12.17.44-1.el7.x86_64.rpm*')
system('mkdir /etc/chef')
system('yum install git')
system('git clone https://github.com/coltonglasgow/chef-elkbox /etc/chef/')
system('chef-client --local-mode /etc/chef/elkbox.rb')
