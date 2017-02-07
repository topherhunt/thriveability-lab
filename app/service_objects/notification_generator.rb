# This class should be invoked every time a notable events happens on the site.
# It's responsible for deciding who should be notified when something happens,
# and creating Notification records as relevant.
class NotificationGenerator
  def initialize(actor, action, target)
    @actor = actor
    @action = action
    @target = target

    if @action == :published_post and !@target.root?
      @action = :commented_on_post
      @target_comment = @target
      @target = @target.root # @target should point to the top-level Post
    end
  end

  def run
    users_to_notify.each do |user_id|
      Notification.create!(notify_user_id: user_id, actor: @actor, action: @action, target: @target)
    end
  end

  def users_to_notify
    user_ids = case @action
    when :updated_profile
      follower_ids_for(@actor)
    when :created_project
      follower_ids_for(@actor)
    when :created_resource
      follower_ids_for(@actor)
    when :published_post
      follower_ids_for(@actor)
    when :commented_on_post
      [ follower_ids_for(@actor),
        follower_ids_for(@target),
        @target_comment.ancestors.pluck(:author_id) ]
    when :liked_object
      [ follower_ids_for(@actor),
        follower_ids_for(@target), # Too spammy?
        owner_id_for(@target) ]
    when :followed_object
      [ follower_ids_for(@actor),
        follower_ids_for(@target), # Too spammy?
        owner_id_for(@target) ]
    else
      raise "Unknown notification action '#{@action}'!"
    end

    user_ids.flatten.uniq.reject{ |id| id == @actor.id }
  end

  def follower_ids_for(object)
    StayInformedFlag.where(target: object).pluck(:user_id)
  end

  def owner_id_for(object)
    case object.class.to_s
    when "User"     then object.id
    when "Project"  then object.owner_id
    when "Post"     then object.author_id
    when "Resource" then object.creator_id
    else
      raise "Don't know how to look up the owner for #{object.class.to_s} #{object.id}!"
    end
  end
end
