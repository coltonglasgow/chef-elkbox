#reboot.rb
print "\e[H\e[2J"
print('Your system needs to reboot. ====> Type "reboot" = auto reboot or ctrl+c = close and reboot later.') 

while ans = gets.chomp
case ans
when 'reboot'
print "\e[H\e[2J"
 #restarting
 7.times do |i|
	print "Rebooting." + ("." * (i % 3)) + " \r"
	$stdout.flush
	sleep(0.5)
 end 
system('reboot')
else
print "\e[H\e[2J"
print 'Try again. Type "reboot" = auto reboot or ctrl+c = close and reboot later.'
end
end
