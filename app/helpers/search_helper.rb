module SearchHelper
  def label_for_class(class_name)
    class_name.sub("User", "Person").pluralize
  end
end
