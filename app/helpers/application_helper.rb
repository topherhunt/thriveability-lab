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

  def predefined_tag_list
    Rails.cache.fetch('predefined_tag_list', expires_in: 1.day) do
      PredefinedTag.all.order(:name).pluck(:name).map{ |name| link_to(name, "#", class: "js-add-tag", "data-target": "#project-tags-tagit") }.join(", ").html_safe
    end
  end

  def most_common_30_tags
    Rails.cache.fetch('most_common_30_tags', expires_in: 1.day) do
      Project.tag_counts_on(:tags)
        .sort_by{ |i| -i.taggings_count }
        .map(&:name)[0..29]
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

  def required_label(form, field, title=nil)
    form.label field, "#{(title || field).to_s.humanize} <span class='text-danger'>*</span>".html_safe
  end
end
