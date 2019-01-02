require "test_helper"

class ProjectMessagesTest < Capybara::Rails::TestCase
  setup do
    @project = create(:project)
    @user = create(:user)
  end

  test "User can send a message to another user" do
    assert_equals 0, Message.count
    sign_in @user
    send_message_about_project(@project)
    assert_message_record_saved(@user, @project)
    assert_message_emails_sent(@user, @project)
  end

  test "Visitor is required to log in before sending a message" do
    visit project_path(@project)
    page.find('.new-project-message-link').click
    assert_path root_path
  end

  # === Helpers ===

  def send_message_about_project(project)
    visit project_path(project)
    page.find('.new-project-message-link').click
    assert_path new_message_path
    select Message::PROJECT_SUBJECT_PRESETS.second, from: 'message[subject]'
    fill_in 'message[body]', with: "Test message body"
    click_on "Send!"
    assert_path project_path(project)
    assert_content "Your message has been sent"
  end

  def assert_message_record_saved(sender, project)
    assert_equals 1, Message.count
    message = Message.first
    assert_equals project, message.project
    assert_equals project.owner, message.recipient
    assert_equals sender, message.sender
    assert_equals Message::PROJECT_SUBJECT_PRESETS.second, message.subject
    assert_equals "Test message body", message.body
    assert message.sent_at.between?(1.second.ago, Time.now)
  end

  def assert_message_emails_sent(sender, project)
    assert_equals 2, ActionMailer::Base.deliveries.count
    mail_to_recipient = ActionMailer::Base.deliveries.first
    assert_equals [project.owner.email], mail_to_recipient.to
    assert_equals [sender.email], mail_to_recipient.reply_to
    assert_equals nil, mail_to_recipient.cc
    assert mail_to_recipient.subject.include?("New message from #{sender.name}")
    mail_to_sender = ActionMailer::Base.deliveries.second
    assert_equals [sender.email], mail_to_sender.to
    assert_equals nil, mail_to_sender.reply_to
    assert_equals nil, mail_to_sender.cc
    assert mail_to_sender.subject.include?("Your message has been sent to #{project.owner.name}")
  end
end
