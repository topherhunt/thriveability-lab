module ProjectHelper
  def content_for_project_popover(project)
    buffer = ""
    if project.tag_list.any?
      buffer << "<p>" + sanitize(project.tag_list.join(", "), tags: []) + "</p>"
    end
    buffer << "<p>started by #{sanitize project.owner.full_name, tags: []}</p>"
    if project.received_stay_informed_flags.count > 0
      buffer << "<p>#{project.received_stay_informed_flags.count} followers</p>"
    end
    buffer
  end
end
