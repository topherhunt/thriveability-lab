require "test_helper"

class EventTest < ActiveSupport::TestCase
  describe ".register" do
    test "when updating profile: notifies the actor's followers" do
      actor = create(:user)
      follower = create(:user); create_follow(follower, actor)

      event = Event.register(actor, :update, actor)
      assert_notified event, [follower]
    end

    test "when creating an object: notifies the actor's followers" do
      actor = create(:user)
      follower = create(:user); create_follow(follower, actor)
      project = create(:project, owner: actor)

      event = Event.register(actor, :create, project)
      assert_notified event, [follower]
    end

    test "when starting a conversation: notifies the actor's followers" do
      actor = create(:user)
      follower = create(:user); create_follow(follower, actor)
      convo = create(:conversation, creator: actor)

      event = Event.register(actor, :create, convo)
      assert_notified event, [follower]
    end

    test "when commenting on a conversation: notifies the actor's followers and the conversation's followers" do
      actor = create(:user)
      actor_follower = create(:user); create_follow(actor_follower, actor)
      convo = create(:conversation)
      convo_follower = create(:user); create_follow(convo_follower, convo)
      first_comment = create(:comment, context: convo)
      new_comment = create(:comment, author: actor, context: convo)

      event = Event.register(actor, :comment, convo)
      assert_notified event, [actor_follower, convo_follower]
    end

    test "when liking something: notifies the target's owner / creator" do
      actor = create(:user)
      actor_follower = create(:user); create_follow(actor_follower, actor)
      resource = create(:resource)
      resource_follower = create(:user); create_follow(resource_follower, resource)

      event = Event.register(actor, :like, resource)
      assert_notified event, [resource.creator]
    end

    test "when following something: notifies the target's owner / creator" do
      actor = create(:user)
      actor_follower = create(:user); create_follow(actor_follower, actor)
      resource = create(:resource)
      resource_follower = create(:user); create_follow(resource_follower, resource)

      event = Event.register(actor, :follow, resource)
      assert_notified event, [resource.creator]
    end

    test "never notifies the same person twice for the same event" do
      actor = create(:user)
      actor_follower = create(:user); create_follow(actor_follower, actor)
      resource = create(:resource, creator: actor_follower)
      create_follow(actor_follower, resource)

      event = Event.register(actor, :follow, resource)
      assert_equals 1, event.notifications.count
    end

    test "never notifies the actor for their own event" do
      actor = create(:user)
      create_follow(actor, actor)
      resource = create(:resource, creator: actor)
      create_follow(actor, resource)

      event = Event.register(actor, :follow, resource)
      assert_equals 0, event.notifications.count
    end
  end

  def create_follow(user, object)
    StayInformedFlag.create!(user: user, target: object)
  end

  def assert_notified(event, expected_users)
    notified_users = event.notifications.map(&:notify_user)
    expected_users.each do |expected_user|
      assert notified_users.include?(expected_user), "Expected user #{expected_user.id} to be notified of event #{event.id}, but they weren't."
    end
    assert_equal expected_users.count, notified_users.count
  end
end
