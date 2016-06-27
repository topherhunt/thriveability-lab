module DateHelper
  def print_date(input, opts={})
    return unless input.present?
    weekday_flag = opts[:abbreviated] ? "%a" : "%A"
    month_flag = opts[:abbreviated] ? "%b" : "%B"
    output = ""
    output += input.strftime("#{weekday_flag}, ") if opts[:weekday]
    output += input.strftime("#{month_flag} %e")
    output += ", #{input.year}" if input.year != Time.now.year or opts[:year]
    output += input.strftime(", %l:%M %P") if opts[:time]
    output.gsub(/\s+/, ' ').strip
  end

  def print_time(input)
    return unless input.present?
    input.strftime("%l:%M %P").strip
  end
end
