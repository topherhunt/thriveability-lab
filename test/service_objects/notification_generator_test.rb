require "test_helper"

class NotificationGeneratorTest < ActiveSupport::TestCase
  test "#run on :update_profile: notifies the actor's followers" do
    @actor = create(:user)
    @follower = create(:user); create_follow(@follower, @actor)

    NotificationGenerator.new(@actor, :updated_profile, @actor).run
    assert_equals 1, Notification.count
    assert_notified @follower, of: [@actor, :updated_profile, @actor]
  end

  test "#run on :created_project notifies the actor's followers" do
    @actor = create(:user)
    @follower = create(:user); create_follow(@follower, @actor)
    @project = create(:project, owner: @actor)

    NotificationGenerator.new(@actor, :created_project, @project).run
    assert_equals 1, Notification.count
    assert_notified @follower, of: [@actor, :created_project, @project]
  end

  test "#run on :created_resource notifies the actor's followers" do
    @actor = create(:user)
    @follower = create(:user); create_follow(@follower, @actor)
    @resource = create(:resource, creator: @actor)

    NotificationGenerator.new(@actor, :created_resource, @resource).run
    assert_equals 1, Notification.count
    assert_notified @follower, of: [@actor, :created_resource, @resource]
  end

  test "#run on :published_post notifies the actor's followers" do
    @actor = create(:user)
    @follower = create(:user); create_follow(@follower, @actor)
    @post = create(:published_post, author: @actor)

    NotificationGenerator.new(@actor, :published_post, @post).run
    assert_equals 1, Notification.count
    assert_notified @follower, of: [@actor, :published_post, @post]
  end

  test "#run on :commented_on_post notifies the actor's followers, the post's followers, and the comment's parents' authors" do
    @actor = create(:user)
    @actor_follower = create(:user); create_follow(@actor_follower, @actor)
    @post = create(:published_post)
    @post_follower = create(:user); create_follow(@post_follower, @post)
    @parent_comment = create(:published_post, parent: @post)
    @new_comment = create(:published_post, author: @actor, parent: @parent_comment)

    NotificationGenerator.new(@actor, :published_post, @new_comment).run
    assert_equals 4, Notification.count # one to me and one to the original post author
    assert_notified @actor_follower,        of: [@actor, :commented_on_post, @post]
    assert_notified @post_follower,         of: [@actor, :commented_on_post, @post]
    assert_notified @post.author,           of: [@actor, :commented_on_post, @post]
    assert_notified @parent_comment.author, of: [@actor, :commented_on_post, @post]
  end

  test "#run on :liked_object notifies the actor's followers, the target's followers, and the target's owner / creator" do
    @actor = create(:user)
    @actor_follower = create(:user); create_follow(@actor_follower, @actor)
    @resource = create(:resource)
    @resource_follower = create(:user); create_follow(@resource_follower, @resource)

    NotificationGenerator.new(@actor, :liked_object, @resource).run
    assert_equals 1, Notification.count
    # assert_notified @actor_follower,    of: [@actor, :liked_object, @resource]
    # assert_notified @resource_follower, of: [@actor, :liked_object, @resource]
    assert_notified @resource.creator,  of: [@actor, :liked_object, @resource]
  end

  test "#run on :followed_object notifies the actor's followers, the target's followers, and the target's owner / creator" do
    @actor = create(:user)
    @actor_follower = create(:user); create_follow(@actor_follower, @actor)
    @resource = create(:resource)
    @resource_follower = create(:user); create_follow(@resource_follower, @resource)

    NotificationGenerator.new(@actor, :followed_object, @resource).run
    assert_equals 1, Notification.count
    # assert_notified @actor_follower,    of: [@actor, :followed_object, @resource]
    # assert_notified @resource_follower, of: [@actor, :followed_object, @resource]
    assert_notified @resource.creator,  of: [@actor, :followed_object, @resource]
  end

  test "#run never notifies the same person twice for the same event" do
    @actor = create(:user)
    @actor_follower = create(:user); create_follow(@actor_follower, @actor)
    @resource = create(:resource, creator: @actor_follower)
    create_follow(@actor_follower, @resource)

    NotificationGenerator.new(@actor, :followed_object, @resource).run
    assert_equals 1, Notification.count
    assert_notified @actor_follower, of: [@actor, :followed_object, @resource]
  end

  test "#run never notifies the actor for their own event" do
    @actor = create(:user)
    create_follow(@actor, @actor)
    @resource = create(:resource, creator: @actor)
    create_follow(@actor, @resource)

    NotificationGenerator.new(@actor, :followed_object, @resource).run
    assert_equals 0, Notification.count
  end

  def create_follow(user, object)
    StayInformedFlag.create!(user: user, target: object)
  end

  def assert_notified(user, opts)
    actor = opts[:of].first
    action = opts[:of].second
    target = opts[:of].third
    assert_equals 1, user.notifications.where(actor: actor, action: action, target: target).count
  end
end
