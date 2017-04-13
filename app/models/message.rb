class Message < ActiveRecord::Base
  # To prevent abuse of our messaging system to send spam or misleading emails,
  # only a set list of subject lines are allowed. That way every user message
  # we send out has a clearly stated purpose, and the recipient should be able
  # to clearly understand what we think we're sending (regardless of what text
  # the user types into the email body).
  SUBJECTS = {
    'project_question' => "I have a question about your project",
    'project_suggestion' => "I have ideas or feedback about your project",
    'project_get_involved' => "I'd like to get involved with your project"
  }

  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'
  belongs_to :project # optional

  validates_presence_of :sender
  validates_presence_of :recipient
  # validates_presence_of :project # for now; in the future this might be optional
  validates_presence_of :subject_code
  validates_presence_of :body
  validates :subject_code, inclusion: { in: SUBJECTS.keys }
  validate :project_must_belong_to_recipient

  def project_must_belong_to_recipient
    if project_id and project.owner_id != recipient_id
      errors.add(:base, "#{recipient.try(:full_name)} doesn't own project #{project.title}. Please return to the project's profile page and try sending a new message.")
    end
  end

  def full_subject
    "New message from #{sender.full_name}: \"#{SUBJECTS[subject_code]}\""
  end

  def send!
    MessagesMailer.new_message_received(self).deliver_now
    MessagesMailer.new_message_sent(self).deliver_now
    update!(sent_at: Time.now)
  end
end
