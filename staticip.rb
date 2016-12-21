#static IP
prompt1 = 'New Static IP: '
prompt2 = 'New Netmask: '
prompt3 = 'DNS 1: '
prompt4 = 'DNS 2: '
prompt5 = 'Hostname: '

#static IP
print "\e[H\e[2J"
puts prompt1
static = gets.chomp 

#netmask
print "\e[H\e[2J"
puts prompt2
netmask = gets.chomp

#dns1
print "\e[H\e[2J"
puts prompt3
dns1 = gets.chomp

#dns2
print "\e[H\e[2J"
puts prompt4
dns2 = gets.chomp

#hostname
print "\e[H\e[2J"
puts prompt5
hostname = gets.chomp

out_file = File.new("/etc/sysconfig/network-scripts/ifcfg-enp0s3", "r+")
out_file.puts(
'BOOTPROTO=static',
'IPADDR=', static, 
'NETMASK=',netmask,
'dns1', dns1,
'dns2', dns2,
'hostname', hostname,
'ONBOOT=yes')

out_file.close


print "\n"
print "Is this correct? (y or n) OR "
print ' type "full" to see fully updated file.'
print "\n"
while yorn = gets.chomp
case yorn
#no
when 'n'
 puts "\e[H\e[2J"
 #retrying
 7.times do |i|
	print "Retrying." + ("." * (i % 3)) + " \r"
	$stdout.flush
	sleep(0.5)
 end
 system("ruby usrinput.rb")
#full
when "full"
 puts "\e[H\e[2J"

puts IO.read("/etc/sysconfig/network-scripts/ifcfg-enp0s3")
 print '\n'
 puts 'Is this information correct? (y or n)'
 when 'y'
 system('exit')
 when 'n'
  #retrying
 7.times do |i|
	print "Retrying." + ("." * (i % 3)) + " \r"
	$stdout.flush
	sleep(0.5)
 end
 system("ruby usrinput.rb")
#yes
when 'y'
system("exit")
else
puts "\e[H\e[2J"
puts 'Please enter y or n. '
print 'Type "full" to see fully updated file'
puts "Is the IP and netmask correct? (y or n)"
end
end


#ifconfig '192.168.5.185' do
#	bootproto 'static'
#	device 'enp0s3'
#	mask '255.255.255.0'
#	onboot 'yes'
#end
