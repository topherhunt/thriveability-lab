class ConversationParticipantJoin < ApplicationRecord
  INTENTION_PRESETS = [
    "share objective facts",
    "share my experience or perspective",
    "seek others' experience or perspective",
    "raise a question",
    "offer ideas or advice",
    "seek ideas or advice",
    "something else"
  ]

  belongs_to :conversation
  belongs_to :participant, class_name: "User"

  validates :conversation_id, presence: true
  validates :participant_id, presence: true
  validates :intention, presence: true, length: {maximum: 255}
end
