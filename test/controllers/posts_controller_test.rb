require "test_helper"

# I almost never use controller specs. These are only here so I have an easy
# template to copy from if I need to test some advanced controller logic.

class PostsControllerTest < ActionController::TestCase
  tests PostsController

  it "requires login on all actions except :index, :search, :show"
  it "requires authorship on :edit, :update, :destroy"

  setup do
    @user = create :user
    sign_in @user
  end

  context "#index" do
    it "works"
  end

  context "#drafts" do
    it "lists my drafts (and nothing else)" do
      post1 = create :published_post, author: @user
      post2 = create :draft_post, author: @user
      post3 = create :draft_post # by another user
      post4 = create :draft_post, author: @user

      get :drafts
      assert_visible [post2, post4]
      assert_not_visible [post1, post3]
    end
  end

  context "#create" do
    it "works"
  end

  context "#edit" do
    test "user can edit their own draft" do
      post = create :draft_post, author: @user, draft_content: "my test content"
      get :edit, id: post.id
      assert_content "my test content"
    end

    test "user can edit a published post" do
      post = create :published_post, author: @user, published_content: "test content"
      get :edit, id: post.id
      assert_content "test content"
    end

    test "user can't edit another user's draft" do
      post = create :draft_post # by another user
      get :edit, id: post.id
      assert_redirected_to post_path(post.id)
    end
  end

  context "#update" do
    it "works"
  end

  context "#show" do
    it "works"

    test "user can't view a draft (even their own)" do
      post = create :draft_post, author: @user
      get :show, id: post.id
      assert_redirected_to posts_path
    end
  end

  context "#destroy" do
    it "works"
  end

  def assert_visible(posts)
    posts.each { |p| assert_content p.title }
  end

  def assert_not_visible(posts)
    posts.each { |p| assert_no_content p.title }
  end
end
