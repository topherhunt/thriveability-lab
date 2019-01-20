require "test_helper"

class UserProfileTest < Capybara::Rails::TestCase
  test "user can view and edit their profile" do
    user = create :user
    UserProfilePrompt::TEMPLATES.shuffle.take(3).each do |stem|
      create :user_profile_prompt, user: user, stem: stem
    end

    sign_in user
    visit root_path

    click_on "My Profile"
    assert_content user.tagline

    page.find(".test-edit-user").click
    fill_fields(
      user_name: "a new name",
      user_tagline: "a tagline",
      user_location: "a location",
      prompts_2_response: "prompt response #1",
      prompts_4_response: "prompt response #2",
      prompts_6_response: "prompt response #3"
    )
    attach_file("user_image", "#{Rails.root}/test/fixtures/test.png")
    page.find(".test-submit-user-profile").click

    assert_content "Your profile has been updated"
    user = User.find(user.id)
    prompt_responses = user.profile_prompts.pluck(:response)
    assert_content "a new name"
    assert_content "a tagline"
    assert_content "a location"
    assert_content "prompt response #1"
    assert_content "prompt response #2"
    assert_content "prompt response #3"
  end
end
