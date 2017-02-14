module TextHelper
  def ellipsify(string, max)
    if string.present? and string.length > max
      string[0..(max-1)] + "..."
    else
      string
    end
  end
end
