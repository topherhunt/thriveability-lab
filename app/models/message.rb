class Message < ActiveRecord::Base
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

  def full_subject
    "New message from #{sender.full_name}: \"#{subject}\""
  end

  def send!
    MessagesMailer.new_message_received(self).deliver_now
    MessagesMailer.new_message_sent(self).deliver_now
    update!(sent_at: Time.now)
  end
end
