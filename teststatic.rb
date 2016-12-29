#test
puts "\e[H\e[2J"
5.times do |i|
		print "Testing Connection." + ("." * (i % 3)) + " \r"
		$stdout.flush
		sleep(0.5)
end

system('ping localhost -c 3 > /etc/chef/staticiplog.txt')
system('ping google.com -c 3 > /etc/chef/staticipgooglog.txt')

File.open '/etc/chef/staticipgooglog.txt' do |file|
	if file.find { |line| line =~ /3 received/ }
	puts "\e[H\e[2J"
	puts 'Successfully reached google.com.'
	else 
	puts 'Could not reach google.com. '
	end
	end

File.open '/etc/chef/staticiplog.txt' do |file|
	if file.find { |line| line =~ /3 received/ }
	puts 'Successfully reached localhost.' 
	else
	puts "\e[H\e[2J"
	puts 'Cannot ping localhost. Press "r" to retry'
	while ans = gets.chomp
	case ans
	#r
	when ans = 'r'
	puts "\e[H\e[2J"
		#retrying
		7.times do |i|
		print "Retrying." + ("." * (i % 3)) + " \r"
		$stdout.flush
		sleep(0.5)
		end
		system("ruby /etc/chef/staticip.rb")
end
end
end
end
