class LikeFlag < ApplicationRecord
  # TODO: Should there be a unique constraint on user + target?
  belongs_to :user
  belongs_to :target, polymorphic: true

  validates :user_id,     presence: true
  validates :target_type, presence: true
  validates :target_id,   presence: true

  scope :latest, ->(n) { order("created_at DESC").limit(n) }
end
