class LikeFlag < ActiveRecord::Base
  belongs_to :user
  belongs_to :target, polymorphic: true, counter_cache: true

  validates :user_id,     presence: true
  validates :target_type, presence: true
  validates :target_id,   presence: true

end
