require "test_helper"

class CommentsTest < Capybara::Rails::TestCase
  include ActionView::Helpers::SanitizeHelper

  setup do
    @user = create(:user)
    login_as @user
  end

  test "User can start a conversation" do
    visit root_path
    click_on "Conversations"
    find(".test-new-conversation-link").click
    fill_in "conversation[title]", with: "Convo title"
    fill_in "intention", with: "My first intention statement"
    find("#comment_body", visible: false).set("Some body")
    click_on "Start this conversation!"
    conversation = @user.conversations.last
    assert conversation.present?
    assert_path conversation_path(conversation)
    assert_content "Convo title"
    assert_html "My first intention statement"
    assert_content "Some body"
    visit conversations_path
    assert_selector ".test-conversation-link", text: "Convo title"
  end

  test "User view a conversation, add a comment, edit it, and delete it" do
    conversation = create :conversation
    comment1 = create :comment, context: conversation, author: conversation.creator
    comment2 = create :comment, context: conversation, body: "A second comment"

    visit conversation_path(conversation)
    assert_content conversation.title
    assert_content conversation.creator.full_name
    assert_content "A second comment"
    # Adding a comment
    fill_in "intention", with: "New commenter intention statement"
    find("#comment_body", visible: false).set("A third comment body")
    click_on "Post comment"
    assert_content "Your comment was posted!"
    assert_equals 1, @user.comments.count
    my_comment = @user.comments.last
    assert_html "New commenter intention statement"
    assert_content "A third comment body"
    # Editing my comment
    find(".test-edit-comment").click
    assert_path edit_comment_path(@user.comments.last)
    find("#comment_body", visible: false).set("New body text")
    click_on "Save"
    assert_equals "New body text", my_comment.reload.body
    # Deleting my comment
    find(".test-delete-comment").click
    assert_path conversation_path(conversation)
    assert_no_content "New body text"
    assert_equals 0, @user.comments.count
    # I can add a second comment, and am not asked my intention this time
    find("#comment_body", visible: false).set("A second comment")
    click_on "Post comment"
    assert_equals 1, @user.comments.count
  end
end
