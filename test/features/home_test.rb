require "test_helper"

class HomeTest < Capybara::Rails::TestCase
  test "home page loads correctly" do
    visit root_path
    assert_content "Integral Climate"
    assert_content "People"
    assert_content "Projects"
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
