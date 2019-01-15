# Rails uses WEBrick as the default dev server. I'm fine with this but not
# OK with WEBrick's verbose logging defaults and don't see an easy way to
# adjust the config, so I'll monkeypatch.
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
