# chef-elkbox
Downloading the files and running with chef:

Make a chef directory to download the files to:
	sudo mkdir /etc/chef

Install git to download the files: 
--sudo yum install git

Download the files:
--sudo git clone https://github.com/coltonglasgow/chef-elkbox /etc/chef

Move the files to the chef folder:
--sudo mv chef-elkbox/* /etc/chef

Install Chef from the chef website. This script will only work on CentOS so below I have provided the direct download link:
-- https://packages.chef.io/files/stable/chef/12.17.44/el/7/chef-12.17.44-1.el7.x86_64.rpm

Command to run the elkbox.rb (my chef file):
--Sudo chef-client –local-mode /etc/chef/elkbox.rb

**BEFORE RUNNING** when the prompt opens for a new static IP just press ctrl+c to exit out of that specific dialog. At this time, it will only mess up your internet connection (It is a work in progress). 
