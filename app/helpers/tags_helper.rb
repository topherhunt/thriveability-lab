module TagsHelper

  def popular_project_tags(limit)
    Project.tag_counts_on(:tags)
      .sort_by{ |i| -i.taggings_count }
      .map(&:name)[0..(limit-1)]
      .sort
  end

  def popular_post_tags(limit)
    Post.published.tag_counts_on(:tags)
      .sort_by{ |i| -i.taggings_count }
      .map(&:name)[0..(limit-1)]
      .sort
  end

  def popular_resource_tags(limit)
    Resource.tag_counts_on(:tags)
      .sort_by{ |i| -i.taggings_count }
      .map(&:name)[0..(limit-1)]
      .sort
  end

end
