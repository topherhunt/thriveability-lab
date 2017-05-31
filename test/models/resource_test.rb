require "test_helper"

class ResourceTest < ActiveSupport::TestCase
  def set_popularity(target, number)
    LikeFlag.where(target: target).delete_all
    number.times { create :like_flag, target: target }
  end

  test "ensures URL contains a protocol" do
    resource = create(:resource, current_url: "foo")
    assert_equals "http://foo", resource.reload.current_url

    resource2 = create(:resource, current_url: "https://foo")
    assert_equals "https://foo", resource2.reload.current_url
  end
end
