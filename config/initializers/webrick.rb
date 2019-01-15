# Silence WEBrick's verbose per-request logging
# See https://github.com/ruby/ruby : /lib/webrick/httpserver.rb
if Rails.env.development?
  require 'webrick'

  module WEBrick
    class HTTPServer
      def access_log(a, b, c)
        nil
      end
    end
  end
end
