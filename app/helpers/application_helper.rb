module ApplicationHelper
  def active_if_current(path)
    "active" if request.path.include?(path)
  end

  def bootstrap_flash_class(key)
    case key.to_sym
    when :notice
      'info'
    when :alert
      'warning'
    else
      raise "Unrecognized flash key '#{key.to_s}'!"
    end
  end

  def show_errors_for (object)
    render 'shared/errors', object: object if object.errors.any?
  end

  def show_inline_errors_for(record, field)
    if record.errors[field].any?
      content_tag :div, class: "inline-errors" do
        record.errors[field].map{ |e| "This field #{e}" }.join("; ")
      end
    end
  end

  def required
    '<em class="small text-danger">required</em>'.html_safe
  end
end
