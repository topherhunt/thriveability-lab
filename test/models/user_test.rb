require "test_helper"

class UserTest < ActiveSupport::TestCase
  def set_popularity(target, number)
    LikeFlag.where(target: target).delete_all
    number.times { create :like_flag, target: target }
  end

  test ".most_recent returns the most recently signed-in users" do
    u3 = create :user, current_sign_in_at: 1.days.ago
    u2 = create :user, current_sign_in_at: 2.days.ago
    u1 = create :user, current_sign_in_at: 3.days.ago
    u4 = create :user, current_sign_in_at: 4.days.ago
    u5 = create :user, current_sign_in_at: 5.days.ago
    assert_equals [u3, u2, u1, u4, u5].map(&:id), User.most_recent(5).pluck(:id).to_a
  end
end
