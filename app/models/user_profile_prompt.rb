class UserProfilePrompt < ApplicationRecord
  include TextHelper

  TEMPLATES = [
    "I'm passionate about",
    "I dream of a future",
    "I'm inspired by",
    "I feel most alive",
    "I'm proud of",
    "My current focus is on",
    "I'm good at",
    "I'm looking for",
    "One skill I can offer is",
    "My professional goal is",
    "I joined this site because"
  ]

  belongs_to :user

  validates :user_id,  presence: true
  validates :stem,     presence: true, length: {maximum: 100} # (not yet user-editable)
  validates :response, presence: true, length: {maximum: 200}

  def sentence
    ensure_ending_period("#{stem} #{response}")
  end
end
