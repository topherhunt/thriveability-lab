require "test_helper"

class UserProfileTest < Capybara::Rails::TestCase
  setup do
    @user = create(:user)
  end

  test "User can fill in profile info" do
    login_as @user
    click_on "My Profile"
    click_on "Edit"
    assert_path edit_user_path(@user)
    fill_fields(
      "user[name]" => "Elmer Fudd",
      "user[skill_list]" => "knitting, hunting",
      "user[passion_list]" => "cartoons, wacky wabbits",
      "user[trait_list]" => "diligent, stealthy, tireless, patient",
      "user[dream_of_future_where]" => "all men are created equal")
    attach_file "user[image]", "#{Rails.root}/public/test/elmerfudd.jpg"
    # page.should have_selector ".dream-of-future-exemplars"
    click_button "Save"
    assert_path user_path(@user)
    assert_content "Your profile has been updated."
    expect_attributes(@user.reload,
      name: "Elmer Fudd",
      image_file_name: "elmerfudd.jpg",
      skill_list: ["knitting", "hunting"],
      passion_list: ["cartoons", "wacky wabbits"],
      trait_list: ["diligent", "stealthy", "tireless", "patient"],
      dream_of_future_where: "all men are created equal")
  end

  test "User profile lists my recent posts" do
    @post1 = create(:published_post) # not mine
    @post2 = create(:published_post, author: @user)
    @post3 = create(:draft_post, author: @user)
    @post4 = create(:published_post, author: @user)
    # some older posts...
    10.times { create(:published_post, author: @user, published_at: 2.weeks.ago) }
    @post5 = create(:published_post, author: @user, published_at: 3.weeks.ago)

    visit user_path(@user)
    assert_content "Recent posts"
    assert_content @post2.title
    assert_content @post4.title
    refute_content @post1.title
    refute_content @post3.title
    refute_content @post5.title # not recent enough / too many recent posts
    click_on @post2.title
    assert_path post_path(@post2)
  end
end
