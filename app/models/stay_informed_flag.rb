class StayInformedFlag < ApplicationRecord
  belongs_to :user
  # target is polymorphic but will only be Project for now.
  belongs_to :target, polymorphic: true

  validates :user_id,     presence: true
  validates :target_type, presence: true
  validates :target_id,   presence: true

  scope :latest, ->(n) { order("created_at DESC").limit(n) }
end
