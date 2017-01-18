require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  def set_popularity(target, number)
    LikeFlag.where(target: target).delete_all
    number.times { create :like_flag, target: target }
  end

  test ".most_popular returns the most popular projects" do
    p1 = create :project
    p2 = create :project
    p3 = create :project
    p4 = create :project
    p5 = create :project
    set_popularity p5, 5
    set_popularity p4, 4
    set_popularity p1, 3
    set_popularity p2, 2
    set_popularity p3, 1
    assert_equals [p5, p4, p1, p2, p3], Project.most_popular(5).to_a
  end
end
