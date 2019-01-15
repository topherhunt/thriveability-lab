# Copied from https://devcenter.heroku.com/articles/rails-unicorn

worker_processes ENV['UNICORN_WORKERS'].to_i
preload_app true
timeout 15

before_fork do |server, worker|
  Signal.trap('TERM') do
    puts "Unicorn master intercepting TERM and sending myself QUIT instead."
    Process.kill 'QUIT', Process.pid
  end
  ApplicationRecord.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap('TERM') do
    puts "Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT."
  end
  ApplicationRecord.establish_connection
end
