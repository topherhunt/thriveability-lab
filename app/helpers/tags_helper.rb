module TagsHelper

  def popular_conversation_tags(limit)
    Conversation.tag_counts_on(:tags)
      .sort_by{ |i| -i.taggings_count }
      .map(&:name)[0..(limit-1)]
      .sort
  end

  def popular_project_tags(limit)
    Project.tag_counts_on(:tags)
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

  def popular_resource_media_types(limit)
    Resource.tag_counts_on(:media_types)
      .sort_by{ |i| -i.taggings_count }
      .map(&:name)[0..(limit-1)]
      .sort
  end

end
