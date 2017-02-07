require "test_helper"

class RunnerTest < ActiveSupport::TestCase
  test "#delete_old_notifications clears out my old notifications" do
    user1 = create(:user)
    user2 = create(:user)
    50.times do
      user1.notifications.create!(actor: user2, action: :updated_profile, target: user2, created_at: 1.day.ago)
      user2.notifications.create!(actor: user1, action: :updated_profile, target: user1, created_at: 1.week.ago)
    end
    5.times do
      user1.notifications.create!(actor: user2, action: :updated_profile, target: user2, created_at: 2.days.ago)
      user2.notifications.create!(actor: user1, action: :updated_profile, target: user1, created_at: 2.weeks.ago)
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
