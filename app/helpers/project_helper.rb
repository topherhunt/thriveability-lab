module ProjectHelper
  def content_for_project_popover(project)
    buffer = ""
    buffer << "<div class='nowrap'><h3 style='margin-top: 0px;'>#{project.title}</h3></div>"
    if project.tag_list.any?
      buffer << "<div class='nowrap'>"
      project.tag_list.each do |word|
        buffer << "<span class='btn btn-default btn-xs'>#{sanitize(word, tags: [])}</span> "
      end
      buffer << "</div>"
    end
    buffer << "<div class='row-padded-top nowrap'>"
    project.involved_users.take(10).each do |user|
      buffer << image_tag(user.image.url(:thumb), class: "img-circle", style: "width: 20px; padding: 1px;")
    end
    buffer << "</div>"
    buffer
  end
end
