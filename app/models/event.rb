# TODO: This class is doing too much - specifically the instance methods.
# They should be extracted to a service class.
class Event < ActiveRecord::Base
  belongs_to :actor, class_name: "User"
  belongs_to :target, polymorphic: true
  has_many :notifications

  validates :actor_id, presence: true
  validates :action, presence: true, inclusion: {in: %w(create update publish like follow)}
  validates :target_type, presence: true, inclusion: {in: %w(User Project Resource Post)}
  validates :target_id, presence: true

  scope :latest, ->(n) { order("id DESC").limit(n) }

  class << self
    def register(actor, action, target)
      event = create!(actor: actor, action: action, target: target)
      event.notify_user_ids.each do |user_id|
        Notification.create!(event: event, notify_user_id: user_id)
      end
      clear_caches(event)
      event
    end

    def clear_caches(event)
      if event.action.to_s.in?(["create", "publish"])
        SafeCacher.delete_matched("user_#{event.actor_id}_recent_contributions")
      end
      SafeCacher.delete_matched("user_#{event.actor_id}_interests")
    end
  end

  def sentence
    "#{actor.full_name} #{action_description} #{target_description}"
  end

  def action_description
    case action.to_s
    when "create"
      case target_type
      when "Project" then "listed the project"
      when "Resource" then "added the resource"
      end
    when "update"
      target_type == "User" ? "updated their profile page" : nil
    when "publish"
      target.root? ? "started the conversation" : "commented on the conversation"
    when "like" then "was inspired by"
    when "follow" then "is now following"
    end || raise("Don't know how to describe event #{id}!")
  end

  def target_description
    target_type.to_s == "User" ? adjusted_target.full_name : adjusted_target.title
  end

  def adjusted_target
    target_type.to_s == "Post" ? target.root : target
  end

  def image_url
    target.respond_to?(:image) ? target.image.url(:thumb) : actor.image.url(:thumb)
  end

  def notify_user_ids
    user_ids = case action.to_s
    when "create" then follower_ids_for(actor)
    when "update" then follower_ids_for(actor)
    when "publish"
      if target.root?
        follower_ids_for(actor)
      else
        [follower_ids_for(actor),
          follower_ids_for(target.root),
          target.ancestors.pluck(:author_id)]
      end
    when "like" then target_owner_id
    when "follow" then target_owner_id
    end || raise("Can't determine who to notify about event #{id}!")
    [user_ids].flatten.uniq.reject{ |id| id == actor_id }
  end

  def follower_ids_for(object)
    StayInformedFlag.where(target: object).pluck(:user_id)
  end

  def target_owner_id
    case target_type.to_s
    when "User"     then target.id
    when "Project"  then target.owner_id
    when "Post"     then target.author_id
    when "Resource" then target.creator_id
    else raise "Don't know how to look up the owner for #{target_type} #{target_id}!"
    end
  end
end
