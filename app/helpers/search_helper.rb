module SearchHelper
  def label_for_model(model_name)
    model_name
      .sub("Post", "Conversation")
      .sub("User", "Person")
      .pluralize
  end
end
