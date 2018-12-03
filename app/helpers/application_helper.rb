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

  def warn_of_length_limit(field_selector, max_length)
    "<div class='js-length-limit-warning' data-target-field='#{field_selector}' data-max-length='#{max_length}'>
      <div class='js-length-90pct text-warning js-hidden'>Close to the maximum length</div>
      <div class='js-length-exceeded text-danger js-hidden'>Text is too long</div>
    </div>".html_safe
  end

  def required
    '<div class="em small text-danger" style="margin-top: -5px; padding-bottom: 3px;">required</div>'.html_safe
  end

  def monitor_connection
    "<div class='js-monitor-connection js-hidden alert alert-danger'><strong>Your connection might be unstable!</strong> Please copy and paste any important changes to somewhere safe before submitting.</div>".html_safe
  end

  def feedback_form_url
    "https://goo.gl/forms/D5v9vsIB3aE4j1kg2"
  end
end
