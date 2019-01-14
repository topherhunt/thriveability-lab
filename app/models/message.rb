class Message < ApplicationRecord
  PROJECT_SUBJECT_PRESETS = [
    "I have a question about your project",
    "I have ideas or feedback about your project",
    "I'd like to get involved with your project"]

  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'
  belongs_to :project # optional

  validates_presence_of :sender
  validates_presence_of :recipient
  # Note that if a user account is deleted, all sent and received messages are deleted
  # Project is NOT required
  validates_presence_of :subject
  validates_presence_of :body
  validates :subject, length: {maximum: 100}
  validates :body, length: {maximum: 1000}

  def full_subject
    "New message from #{sender.name}: \"#{subject}\""
  end

  def send!
    MessagesMailer.new_message_received(self).deliver_now
    MessagesMailer.new_message_sent(self).deliver_now
    update!(sent_at: Time.now)
  end
end
