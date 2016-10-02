class StayInformedFlag < ActiveRecord::Base
  belongs_to :user
  # target is polymorphic but will only be Project for now.
  belongs_to :target, polymorphic: true

  validates :user_id,     presence: true
  validates :target_type, presence: true
  validates :target_id,   presence: true
end
