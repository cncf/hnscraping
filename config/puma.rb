app_path = Dir.getwd

bind "unix:///tmp/puma.sock"
pidfile "/tmp/puma.pid"
state_path "/tmp/puma.state"
stdout_redirect "#{app_path}/log/puma.stdout.log", "#{app_path}/log/puma.stderr.log", true
rackup "#{app_path}/config.ru"

threads 4, 8

activate_control_app