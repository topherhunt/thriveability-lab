require "test_helper"

class HomeTest < Capybara::Rails::TestCase
  test "#home renders" do
    # Populate some sample content
    project  = create :project, created_at: 5.days.ago
    post     = create :published_post, created_at: 4.days.ago
    resource = create :resource, created_at: 2.days.ago
    create :like_flag, target: resource, created_at: 1.days.ago

    visit root_path
    assert_content "Integral Climate"
  end

  test "#about renders" do
    visit root_path
    click_on "About"
    assert_content "We're Integral Climate"
  end

  test "#throwup raises an error for testing" do
    assert_raises(RuntimeError) { visit "/throwup" }
  end
end
