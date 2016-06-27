require "test_helper"

class PostsTest < Capybara::Rails::TestCase
  setup do
    @user = create(:user)
  end

  test "User can create and publish post" do
    login_as @user
    click_on "Posts"
    assert_equals 0, Post.count
    click_on "Write a Post!"
    assert_equals 1, Post.count
    @post = Post.first
    assert_equals @user, @post.author
    fill_fields(
      "post[title]": "Gathering Acorns",
      "post[content]": "Test content" * 100,
      "post[tag_list]": "global warming, icebergs",
      "post[intention_statement]": "Test statement content")
    select "share an update about world events", from: "post[intention_type]"
    click_on "Save as draft"
    assert_path post_path(@post)
    assert_content "This draft is not yet published."
    assert_content "Test content" * 100
    expect_attributes(@post.reload,
      title: "Gathering Acorns",
      content: "Test content" * 100,
      intention_type: "share news",
      intention_statement: "Test statement content",
      tag_list: ["global warming", "icebergs"],
      published: false)
    click_on "Edit"
    click_on "Publish!"
    assert_content "Post published!"
    assert_path post_path(@post)
    assert_equals true, @post.reload.published
  end

  test "User can view and edit their own drafts (but not others')" do
    @post1 = create(:post, author: @user, published: false)
    @post2 = create(:post, published: false) # someone else's
    @post3 = create(:post, author: @user, published: true)
    @post4 = create(:post, published: true)

    login_as @user
    visit posts_path
    refute_content @post1.title
    refute_content @post2.title
    assert_content @post3.title
    assert_content @post4.title
    click_on "View 1 unpublished draft"
    assert_path drafts_posts_path
    assert_content @post1.title
    refute_content @post2.title
    refute_content @post3.title
    refute_content @post4.title
    click_on "Resume"
    assert_path edit_post_path(@post1)
    visit post_path(@post2)
    assert_content "That post doesn't exist."
  end

  test "Visitor can browse and view published posts" do
    @post1 = create(:post, intention_statement: "Foo bar baz test statement")
    @post2 = create(:post)
    @post3 = create(:post, published: false)

    visit posts_path
    assert_content @post1.title
    assert_content @post2.title
    refute_content @post3.title
    click_on @post1.title
    assert_path post_path(@post1)
    assert_content @post1.title
    assert_content @post1.content
    assert_content "Foo bar baz test statement"
    visit post_path(@post3)
    assert_path posts_path
    assert_content "That post doesn't exist."
  end

  test "Visitor can filter published posts by author, intention, and tags" do
    @user1 = create(:user)
    @user2 = create(:user)
    @post1 = create(:post, author: @user1, intention_type: "share news",
      tag_list: "apple, bear")
    @post2 = create(:post, author: @user1, intention_type: "seek perspectives",
      tag_list: "bear, cat")
    @post3 = create(:post, author: @user2, intention_type: "seek perspectives",
      tag_list: "apple, cat")

    visit posts_path
    assert_content "Filter by"
    assert_content @post1.title
    assert_content @post2.title
    assert_content @post3.title
    within("#posts-filters") { click_on @user1.name }
    assert_content @post1.title
    assert_content @post2.title
    refute_content @post3.title
    # filters work additively
    within("#posts-filters") { click_on "seek perspectives" }
    assert_content @post2.title
    refute_content @post1.title
    refute_content @post3.title
    click_on "Clear filters"
    assert_content @post1.title
    assert_content @post2.title
    assert_content @post3.title
    within("#posts-filters") { click_on "apple" }
    assert_content @post1.title
    assert_content @post3.title
    refute_content @post2.title
  end
end
