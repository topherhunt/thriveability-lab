Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.custom_options = lambda do |event|
    {
      pid: Process.pid,
      ip: event.payload[:ip],
      user: event.payload[:user],
      params: event.payload[:params].except(*%w(controller action format id))
    }
  end
  config.lograge.formatter = ->(data) {
    # Data I'm excluding for brevity:
    # - controller=#{data[:controller]}##{data[:action]} (I can infer this)
    # - ip=#{data[:ip]} (Heroku router logs this in case I need it)
    # - "pid=#{data[:pid]} "\
    # Other possible starting chars: █ »
    "■ [#{data[:method]} #{data[:path]}] "\
    "params=#{data[:params]} "\
    "user=#{data[:user]} "\
    "status=#{data[:status]}"\
    "#{data[:location] ? " redirected_to="+data[:location] : ""} "\
    "duration=#{data[:duration]}ms"
  }
end
