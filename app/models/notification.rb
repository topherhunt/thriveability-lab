class Notification < ActiveRecord::Base
  belongs_to :notify_user, class_name: "User"
  belongs_to :actor, class_name: "User"
  belongs_to :target, polymorphic: true

  validates :notify_user_id, presence: true
  validates :actor_id,       presence: true
  validates :action,         presence: true
  validates :target_type,    presence: true
  validates :target_id,      presence: true

  scope :unread, ->{ where read: false }
  scope :read, ->{ where read: true }

  def sentence
    "#{actor.full_name} #{action_description} \"#{target_description}\""
  end

  def action_description
    case action.to_sym
    when :updated_profile   then "updated their profile page"
    when :created_project   then "listed the project"
    when :created_resource  then "added the resource"
    when :published_post    then "started the conversation"
    when :commented_on_post then "commented on the conversation"
    when :liked_object      then "was inspired by"
    when :followed_object   then "is now following"
    else raise "Unexpected action type :#{action}!"
    end
  end

  def target_description
    target.try(:title) || target.try(:full_name)
  end

  def image_url
    if target.respond_to?(:image)
      target.image.url(:thumb)
    else
      actor.image.url(:thumb)
    end
  end
end
