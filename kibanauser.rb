print "\e[H\e[2J"
prompt = 'Please enter a username for the Kibana web interface:'
puts prompt
user_name = gets.chomp

#add_pass = 'xterm -e htpasswd -c /etc/nginx/htpasswd.users ', user_name
#system(add_pass)
system('htpasswd -c /etc/nginx/htpasswd.users ', user_name)
