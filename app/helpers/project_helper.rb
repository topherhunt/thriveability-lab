module ProjectHelper
  def content_for_project_popover(project)
    buffer = ""
    if project.tag_list.any?
      buffer << "<div>"
      project.tag_list.each do |word|
        buffer << "<span class='label label-default'>#{sanitize(word, tags: [])}</span> "
      end
      buffer << "</div>"
    end
    buffer << "<div>Coordinated by #{sanitize project.owner.full_name, tags: []}</div>"
    if project.received_stay_informed_flags.count > 0
      buffer << "<div>#{pluralize project.received_stay_informed_flags.count, "follower"}</div>"
    end
    buffer
  end
end
