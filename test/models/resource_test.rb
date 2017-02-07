require "test_helper"

class ResourceTest < ActiveSupport::TestCase
  def set_popularity(target, number)
    LikeFlag.where(target: target).delete_all
    number.times { create :like_flag, target: target }
  end

  test "ensures URL contains a protocol" do
    resource = create(:resource, url: "foo")
    assert_equals "http://foo", resource.reload.url

    resource2 = create(:resource, url: "https://foo")
    assert_equals "https://foo", resource2.reload.url
  end

  test ".most_popular returns the most popular resources" do
    p1 = create :resource
    p2 = create :resource
    p3 = create :resource
    p4 = create :resource
    p5 = create :resource
    set_popularity p5, 5
    set_popularity p4, 4
    set_popularity p1, 3
    set_popularity p2, 2
    set_popularity p3, 1
    assert_equals [p5, p4, p1, p2, p3], Resource.most_popular.to_a
  end
end
