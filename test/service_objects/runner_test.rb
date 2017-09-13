require "test_helper"

class RunnerTest < ActiveSupport::TestCase
  def add_notification(notify_user, created_at, event_params)
    event = Event.create!(event_params)
    notify_user.notifications.create!(event: event, created_at: created_at)
  end

  test "#delete_old_notifications clears out my old notifications" do
    user1 = create :user
    user2 = create :user
    event_params = {actor: user1, action: "follow", target: user2}
    50.times do
      add_notification(user1, 1.day.ago, event_params)
      add_notification(user2, 1.week.ago, event_params)
    end
    5.times do
      add_notification(user1, 2.days.ago, event_params)
      add_notification(user2, 2.weeks.ago, event_params)
    end

    assert_equals 55, user1.notifications.count
    assert_equals 55, user2.notifications.count
    Runner.delete_old_notifications
    assert_equals 50, user1.notifications.count
    assert_equals 50, user2.notifications.count
    assert user1.notifications.minimum(:created_at) > (1.day.ago - 1.minute)
    assert user2.notifications.minimum(:created_at) > (1.week.ago - 1.minute)
  end
end
