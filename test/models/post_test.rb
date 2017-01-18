require "test_helper"

class PostTest < ActiveSupport::TestCase
  def set_popularity(target, number)
    LikeFlag.where(target: target).delete_all
    number.times { create :like_flag, target: target }
  end

  test ".most_popular returns the most popular published, top-level posts" do
    p1 = create :published_post
    p2 = create :published_post
    p3 = create :published_post
    p4 = create :published_post
    p5 = create :published_post
    p6 = create :published_post, parent: p5
    p7 = create :draft_post
    set_popularity p7, 7
    set_popularity p6, 6
    set_popularity p5, 5
    set_popularity p4, 4
    set_popularity p1, 3
    set_popularity p2, 2
    set_popularity p3, 1
    assert_equals [p5, p4, p1, p2, p3], Post.most_popular.to_a
  end
end
