require "test_helper"

class PostsTest < Capybara::Rails::TestCase
  setup do
    @user = create(:user)
  end

  test "User can create and publish a post" do
    login_as @user
    click_on "Conversations"
    assert_equals 0, Post.count
    click_on "Start a new conversation"
    assert_equals 1, Post.count
    @post = Post.first
    assert_equals @user, @post.author
    fill_in "post[title]", with: "Gathering Acorns"
    fill_in "post[draft_content]", with: "Test content " * 100
    fill_in "post[tag_list]", with: "global warming, icebergs"
    select "seek advice", from: "post[intention]"
    click_on "Save draft"
    assert_path post_path(@post)
    assert_content "Your changes have been saved as a draft."
    assert_content "Unpublished draft"
    assert_content "Test content " * 100
    @post.reload
    assert_equals "Gathering Acorns", @post.title
    assert_equals "Test content " * 100, @post.draft_content
    assert_equals nil, @post.published_content
    assert_equals "seek advice", @post.intention
    assert_equals ["global warming", "icebergs"].to_set, @post.tag_list.to_set
    assert ! @post.published?
    page.find(".edit-post-link").click
    click_on "Publish!"
    assert_content "This post has been published!"
    assert_path post_path(@post)
    @post.reload
    assert_equals true, @post.published
    assert_equals "Test content " * 100, @post.published_content
    assert_equals nil, @post.draft_content
  end

  test "User can view and edit their own drafts (but not others')" do
    @post1 = create(:draft_post, author: @user)
    @post2 = create(:draft_post) # someone else's
    @post3 = create(:published_post, author: @user)
    @post4 = create(:published_post)

    login_as @user
    visit posts_path
    assert_content @post1.title # I see my own drafts
    assert_content "Unpublished draft"
    refute_content @post2.title
    assert_content @post3.title
    assert_content @post4.title
    page.find(".edit-post-link").click
    assert_path edit_post_path(@post1)
    visit post_path(@post2)
    assert_content "That post doesn't exist."
  end

  test "User can write in a custom intention" do
    using_webkit do
      @post = create(:published_post, author: @user)

      login_as @user
      visit edit_post_path(@post)
      select "- other -", from: "post[intention]"
      page.find(".js-intention-write-in").set("My custom intention statement")
      sleep 0.1
      click_on "Publish changes"
      assert_path post_path(@post)
      assert_equals "My custom intention statement", @post.reload.intention
    end
  end

  test "Visitor can browse and view published posts" do
    @post1 = create(:published_post)
    @post2 = create(:published_post)
    @post3 = create(:draft_post)

    visit posts_path
    assert_content @post1.title
    assert_content @post2.title
    refute_content @post3.title
    click_on @post1.title
    assert_path post_path(@post1)
    assert_content @post1.title
    assert_content @post1.published_content
    assert_content @post1.intention
    # can't access an unpubished draft even if I try
    visit post_path(@post3)
    assert_path posts_path
    assert_content "That post doesn't exist."
  end

  test "Visitor can filter published posts by author" do
    @user1 = create(:user)
    @user2 = create(:user)
    @post1 = create(:published_post, author: @user1, intention: "share news",
      tag_list: "apple, bear")
    @post2 = create(:published_post, author: @user1, intention: "seek perspectives",
      tag_list: "bear, cat")
    @post3 = create(:published_post, author: @user2, intention: "seek perspectives",
      tag_list: "apple, cat")

    visit posts_path
    assert_content "Filter by"
    assert_content @post1.title
    assert_content @post2.title
    assert_content @post3.title
    within(".filter-posts") {
      select @user1.full_name, from: "author_id"
      click_button "Filter"
    }
    assert_content @post1.title
    assert_content @post2.title
    refute_content @post3.title
  end
end
