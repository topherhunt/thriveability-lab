require "test_helper"

class UserProfileTest < Capybara::Rails::TestCase
  test "User can fill in profile info" do
    @user = create(:user)
    login_as @user
    click_on "My Profile"
    page.find('a.edit-user').click
    assert_path edit_user_path(@user)
    page.find("#user_first_name").set("Elmer")
    page.find("#user_last_name").set("Fudd")
    page.find("#user_tagline").set("A one-line tagline for my account")
    page.find("#user_bio_interior").set("My dreams, passions, etc.")
    page.find("#user_bio_exterior").set("My work, skills, goals, etc.")
    attach_file "user[image]", "#{Rails.root}/public/test/elmerfudd.jpg"
    page.find(".submit-user-profile").click
    assert_path user_path(@user)
    assert_content "Your profile has been updated."
    @user.reload
    assert_equals "Elmer Fudd", @user.full_name
    assert_equals "A one-line tagline of my account", @user.tagline
    assert_equals "elmerfudd.jpg", @user.image_file_name
    assert_equals "My dreams, passions, etc.", @user.bio_interior
    assert_equals "My work, skills, goals, etc.", @user.bio_exterior
  end

  test "User profile lists my recent posts" do
    @user = create(:user)
    @post1 = create(:published_post) # not mine
    @post2 = create(:published_post, author: @user)
    @post3 = create(:draft_post, author: @user)
    @post4 = create(:published_post, author: @user)
    # some older posts...
    10.times { create(:published_post, author: @user, published_at: 2.weeks.ago) }
    @post5 = create(:published_post, author: @user, published_at: 3.weeks.ago)

    visit user_path(@user)
    assert_content @post2.title
    assert_content @post4.title
    refute_content @post1.title # not mine
    refute_content @post3.title # not published
    refute_content @post5.title # too old (crowded out by more recent posts)
    click_on @post2.title
    assert_path post_path(@post2)
  end
end
