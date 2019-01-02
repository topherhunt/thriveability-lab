require "test_helper"

# I almost never use controller specs. These are only here so I have an easy
# template to copy from if I need to test some advanced controller logic.

class NotificationsControllerTest < ActionController::TestCase
  tests NotificationsController

  setup do
    @user = create :user
    sign_in @user
  end

  context "#index" do
    it "lists all my notifications and their status" do
      create_notifications(@user, unread: 2, read: 1, irrelevant: 3)
      get :index
      assert_select "tr.notification.unread", count: 2
      assert_select "tr.notification.read", count: 1
      assert response.body.include? notification_path(@user.notifications.first)
    end
  end

  context "#show" do
    setup do
      @notification = add_notification(@user, read: false)
    end

    it "marks the notification as read" do
      get :show, id: @notification.id
      assert @notification.reload.read?
    end

    it "redirects to actor if specified" do
      get :show, id: @notification.id, redirect_to: "actor"
      assert_redirected_to user_path(@notification.event.actor)
    end

    it "redirects to target if specified" do
      get :show, id: @notification.id, redirect_to: "target"
      assert_redirected_to user_path(@notification.event.target)
    end
  end

  context "#mark_all_read" do
    it "marks all notifications as read" do
      create_notifications(@user, unread: 2, read: 1, irrelevant: 3)
      assert_equals 1, Notification.read.count
      get :mark_all_read
      assert_equals 3, Notification.read.count # doesn't change irrelevant ones
    end

    it "redirects you back to the referer" do
      request.env['HTTP_REFERER'] = "/wherever"
      get :mark_all_read
      assert_redirected_to "/wherever"
    end
  end

  def create_notifications(user, unread:, read:, irrelevant:)
    other_user = create(:user)
    unread.times { add_notification(user, read: false) }
    read.times { add_notification(user, read: true) }
    irrelevant.times { add_notification(other_user, read: false) }
  end

  def add_notification(recipient, read:)
    @mins_ago ||= 1
    @mins_ago += 1
    # Stub out standard content; we don't care what the notification is about
    @actor ||= create(:user)
    @target ||= create(:user)
    event = Event.create!(
      actor: @actor,
      action: :like,
      target: @target
    )
    recipient.notifications.create!(
      event: event,
      created_at: @mins_ago.minutes.ago,
      read: read
    )
  end
end
