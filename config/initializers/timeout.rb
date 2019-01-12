if defined?(Rack::Timeout)
  Rack::Timeout.timeout = 45 # seconds
  Rack::Timeout::Logger.disable # these are verbose and unnecessary
end
