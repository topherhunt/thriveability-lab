require "test_helper"

class CommentsTest < Capybara::Rails::TestCase
  setup do
    @post = create(:post)
    @user = create(:user)
    create(:post, parent: @post, content: "Word to all of this")
    create_list(:post_conversant, 3, post: @post)
  end

  test "User can join the conversation on a post" do
    login_as @user
    visit post_path(@post)
    # assert_content "Word to all of this" # TODO: visitor can view existing comments
    refute_content "Reply"
    click_on "Join the conversation!"
    assert_equals 3, @post.conversants.count
    assert_content "My intention in joining this conversation"
    select "share facts / research / objective knowledge", from: "post_conversant[intention_type]"
    click_on "Join in!"
    # Not yet joined because I didn't submit all required info
    assert_path post_conversants_path
    assert_equals 3, @post.conversants.count
    assert_content "Intention statement can't be blank"
    fill_in "post_conversant[intention_statement]", with: "test blah foo"
    click_button "Join in!"
    assert_path post_path(@post)
    assert_content "We're glad you've joined the discussion! Reply to this post in-line or at the bottom of the page."
    assert_content "Reply" # now can add a reply
    assert_equals 4, @post.conversants.count
    assert @post.conversants.include?(@user)
  end

  test "User can add comments and reply to others' comments" do
    create(:post_conversant, user: @user, post: @post)

    login_as @user
    visit post_path(@post)
    assert_equals 1, @post.comments.count
    assert_selector "form.reply", count: 0
    page.find(".js-new-reply[data-post-id=\"#{@post.id}\"]").click
    assert_selector "form.reply", count: 1
    assert_content "Ways to support awesome conversation:"
    fill_in "post[content]", with: "My novel and witty response"
    click_on "Publish reply"
    assert_content "1 error prevented this reply from being published"
    select "seek perspectives", from: "comment[intention_type]"
    click_on "Publish reply"
    assert_equals 2, @post.comments.count
    visit post_path(@post)
    assert_content "My novel and witty response"
  end
end
