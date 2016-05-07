require 'rails_helper'
require 'support/feature_helpers'

describe "Posts" do
  before do
    @user = create(:user)
  end

  specify "User can create and publish post" do
    log_in @user
    click_on "Posts"
    Post.count.should eq 0
    click_on "Write a Post!"
    Post.count.should eq 1
    @post = Post.first
    @post.author.should eq @user
    fill_fields(
      "post[title]": "Gathering Acorns",
      "post[content]": "Test content" * 100,
      "post[tag_list]": "global warming, icebergs",
      "post[intention_statement]": "Test statement content")
    select "share an update about world events", from: "post[intention_type]"
    click_on "Save as draft"
    current_path.should eq post_path(@post)
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
    current_path.should eq post_path(@post)
    @post.reload.published.should eq true
  end

  specify "Visitor can browse and view published posts" do
    @post1 = create(:post, intention_statement: "Foo bar baz test statement")
    @post2 = create(:post)
    @post3 = create(:post, published: false)

    visit posts_path
    assert_content @post1.title
    assert_content @post2.title
    refute_content @post3.title
    click_on @post1.title
    current_path.should eq post_path(@post1)
    assert_content @post1.title
    assert_content @post1.content
    assert_content "Foo bar baz test statement"
    visit post_path(@post3)
    current_path.should eq posts_path
    assert_content "That post doesn't exist."
  end

  specify "User can access their own unpublished posts (but not others')" do
    @post1 = create(:post, author: @user, published: false)
    @post2 = create(:post, published: false) # someone else's
    @post3 = create(:post, author: @user, published: true)
    @post4 = create(:post, published: true)

    log_in(@user)
    visit posts_path
    refute_content @post1.title
    refute_content @post2.title
    assert_content @post3.title
    assert_content @post4.title
    click_on "View 1 unpublished draft"
    current_path.should eq drafts_posts_path
    assert_content @post1.title
    refute_content @post2.title
    refute_content @post3.title
    refute_content @post4.title
    click_on "Resume"
    current_path.should eq edit_post_path(@post1)
  end
end
