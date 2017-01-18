require "test_helper"

class HomeTest < Capybara::Rails::TestCase
  def set_popularity(target, number)
    LikeFlag.where(target: target).delete_all
    number.times { create :like_flag, target: target }
  end

  test "home page displays top activity" do
    project = create :project, created_at: 5.days.ago
    post = create :published_post, created_at: 4.days.ago
    comment = create :published_post, parent: post, created_at: 3.days.ago
    resource = create :resource, created_at: 2.days.ago
    likeflag = create :like_flag, target: comment, created_at: 1.days.ago

    visit root_path
    assert_content "Integral Climate"
    assert_content project.title
    assert_content post.title
    assert_content resource.title
    assert_content project.owner.full_name
  end

  test "about page loads correctly" do
    visit root_path
    click_on "About"
    assert_content "We're Integral Climate"
  end

  test "#throwup raises an error for testing" do
    assert_raises(RuntimeError) { visit "/throwup" }
  end
end
