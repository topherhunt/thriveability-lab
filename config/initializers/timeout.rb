if defined?(Rack::Timeout)
  Rack::Timeout::Logger.disable # these are verbose and unnecessary
end
