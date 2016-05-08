require 'rails_helper'
require 'support/feature_helpers'

describe "User profile" do
  before do
    @user = create(:user)
  end

  specify "User can fill in profile info" do
    log_in @user
    click_on "My Profile"
    click_on "Edit"
    assert_equal edit_user_path(@user), current_path
    fill_fields(
      "user[first_name]" => "Elmer",
      "user[last_name]" => "Fudd",
      "user[skill_list]" => "knitting, hunting",
      "user[passion_list]" => "cartoons, wacky wabbits",
      "user[trait_list]" => "diligent, stealthy, tireless, patient",
      "user[dream_of_future_where]" => "all men are created equal")
    attach_file "user[image]", "#{Rails.root}/public/test/elmerfudd.jpg"
    # page.should have_selector ".dream-of-future-exemplars"
    click_button "Save"
    assert_equal user_path(@user), current_path
    assert_content "Your profile has been updated."
    expect_attributes(@user.reload,
      first_name: "Elmer",
      last_name: "Fudd",
      image_file_name: "elmerfudd.jpg",
      skill_list: ["knitting", "hunting"],
      passion_list: ["cartoons", "wacky wabbits"],
      trait_list: ["diligent", "stealthy", "tireless", "patient"],
      dream_of_future_where: "all men are created equal")
  end

  specify "User profile lists my recent posts" do
    @post1 = create(:post, published: true) # not mine
    @post2 = create(:post, author: @user, published: true)
    @post3 = create(:post, author: @user, published: false) # not published
    @post4 = create(:post, author: @user, published: true)
    # some older posts...
    10.times { create(:post, author: @user, published: true, published_at: 2.weeks.ago) }
    @post5 = create(:post, author: @user, published: true, published_at: 3.weeks.ago)

    visit user_path(@user)
    assert_content "Recent posts"
    assert_content @post2.title, @post4.title
    refute_content @post1.title, @post3.title
    refute_content @post5.title # not recent enough / too many recent posts
    click_on @post2.title
    assert_equal post_path(@post2), current_path
  end
end
