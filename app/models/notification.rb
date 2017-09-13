class Notification < ActiveRecord::Base
  belongs_to :event
  belongs_to :notify_user, class_name: "User"

  validates :event_id, presence: true
  validates :notify_user_id, presence: true

  scope :unread, ->{ where read: false }
  scope :read, ->{ where read: true }
  scope :latest, ->{ order("read ASC, created_at DESC") }
end
