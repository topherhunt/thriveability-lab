# TODO: This class is doing too much - specifically the instance methods.
# They should be extracted to a service class.
class Event < ApplicationRecord
  belongs_to :actor, class_name: "User"
  belongs_to :target, polymorphic: true
  has_many :notifications

  validates :actor_id, presence: true
  validates :action, presence: true, inclusion: {in: %w(create update comment like follow)}
  validates :target_type, presence: true, inclusion: {in: %w(User Project Conversation Resource)}
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
    "#{actor.name} #{action_description} #{target_description}"
  end

  def action_description
    case action.to_s
    when "create"
      case target_type
      when "Project" then "listed the project"
      when "Resource" then "added the resource"
      when "Conversation" then "started the conversation"
      end
    when "update" then (target_type == "User" ? "updated their profile page" : nil)
    when "comment" then "commented on the conversation"
    when "like" then "was inspired by"
    when "follow" then "is now following"
    end || raise("Don't know how to describe event #{id} (#{action} #{target_type})!")
  end

  def target_description
    target_type.to_s == "User" ? target.name : target.title
  end

  def image_url
    target.respond_to?(:image) ? target.image.url(:thumb) : actor.image.url(:thumb)
  end

  def notify_user_ids
    user_ids = case action.to_s
    when "create"  then follower_ids_for(actor)
    when "update"  then [follower_ids_for(actor), follower_ids_for(target)]
    when "comment" then [follower_ids_for(actor), follower_ids_for(target)]
    when "like"    then target_owner_id
    when "follow"  then target_owner_id
    end || raise("Can't determine who to notify about event #{id} (#{action} #{target_type})!")
    [user_ids].flatten.uniq.reject{ |id| id == actor_id }
  end

  def follower_ids_for(object)
    StayInformedFlag.where(target: object).pluck(:user_id)
  end

  def target_owner_id
    case target_type.to_s
    when "User"         then target.id
    when "Project"      then target.owner_id
    when "Conversation" then target.creator_id
    when "Resource"     then target.creator_id
    else raise "Don't know how to look up the owner for #{target_type} #{target_id}!"
    end
  end
end
