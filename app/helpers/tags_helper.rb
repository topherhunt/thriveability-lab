module TagsHelper

  def predefined_tag_list
    Rails.cache.fetch('predefined_tag_list', expires_in: 1.day) do
      PredefinedTag.all.order(:name).pluck(:name).map{ |name| link_to(name, "#", class: "js-add-tag", "data-target": "#project-tags-tagit") }.join(", ").html_safe
    end
  end

  def most_common_tags(klass, limit)
    Rails.cache.fetch("#{klass.to_s}_most_common_#{limit}_tags", expires_in: 1.day) do
      klass.tag_counts_on(:tags)
        .sort_by{ |i| -i.taggings_count }
        .map(&:name)[0..(limit-1)]
    end
  end

  def tag_filter_links(tags, route_string)
    tags.map do |name|
      # TODO: This is a XSS vulnerability, right?
      link_to(name, self.send(route_string, tags: name))
    end
  end

end
