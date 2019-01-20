module TextHelper
  def ellipsify(string, max)
    if string.present? and string.length > max
      string[0..(max-1)] + "..."
    else
      string
    end
  end

  def ensure_ending_period(string)
    return if string.blank?
    string = string.strip
    if string =~ /[\.\?\!]\z/
      string
    else
      string + "."
    end
  end
end
