require "test_helper"

class PostsTest < Capybara::Rails::TestCase
  setup do
    @user = create(:user)
  end

  test "post edit form works" do
    login_as @user
    assert_equals 0, @user.posts.count
    start_new_draft
    fill_dummy_content
    click_on "Publish!"
    assert_content "This post has been published!"
    assert_equals 1, @user.posts.count
  end

  test "new post form custom intention JS works" do
    using_webkit do
      login_as @user
      start_new_draft
      fill_dummy_content
      select "- other -", from: "post[intention]"
      page.find(".js-intention-write-in").set("some custom intention")
      click_on "Publish!"
      assert_content "This post has been published!"
      assert_equals "some custom intention", Post.last.author_conversant_record.intention
    end
  end

  it "posts search form works"

  def start_new_draft
    visit posts_path
    page.find(".test-new-conversation-button").click
    assert current_path =~ /\/posts\/\d+\/edit/
  end

  def fill_dummy_content
    fill_in "post[title]", with: "a title"
    fill_in "post[draft_content]", with: "some content"
    select "seek advice", from: "post[intention]"
  end
end
