class ConversationParticipantJoin < ApplicationRecord
  INTENTION_PRESETS = [
    "share about facts, events, or objective knowledge",
    "share about a personal experience or perspective",
    "raise awareness of a problem",
    "propose a solution to a problem",
    "learn about others' perspectives",
    "critique a perspective",
    "seek insights / ideas / advice",
    "offer insights / ideas / advice"
  ]

  belongs_to :conversation
  belongs_to :participant, class_name: "User"

  validates :conversation_id, presence: true
  validates :participant_id, presence: true
  validates :intention, presence: true
end
