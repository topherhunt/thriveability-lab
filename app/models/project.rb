class Project < ActiveRecord::Base
  STAGES = ["idea", "developing", "mature"]

  belongs_to :owner, class_name: 'User'
  has_many :resources, as: :target
  has_many :received_like_flags, class_name: 'LikeFlag', as: :target
  has_many :received_stay_informed_flags, class_name: 'StayInformedFlag', as: :target
  has_many :received_get_involved_flags, class_name: 'GetInvolvedFlag', as: :target

  # See https://github.com/mbleigh/acts-as-taggable-on#usage
  acts_as_taggable_on :tags

  # See https://github.com/thoughtbot/paperclip#quick-start
  has_attached_file :image, styles: { medium: "300x300#", thumb: "100x100#" },
    default_url: "/missing_project.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  validates_presence_of :owner
  validates_presence_of :title
  validates_presence_of :subtitle
  validates_presence_of :stage

  validates :title, length: { maximum: 255 }
  validates :subtitle, length: { maximum: 255 }
  validates :location, length: { maximum: 255 }
  validates :stage, inclusion: { in: STAGES }

  def self.most_popular(n)
    # TODO: This triggers N+1 queries.
    # More efficient approaches to this, for consideration in the long run:
    # - Store result in the Rails cache so it doesn't need to be recomputed each time
    # - Custom SQL query on the like_flags table to get the most liked project_id
    # - Add received_like_flags_count cache column so we can sort by that
    all.sort_by{ |p| -p.received_like_flags.count }.take(n)
  end

  def involved_users
    user_ids = [
      owner_id,
      received_like_flags.pluck(:user_id),
      received_stay_informed_flags.pluck(:user_id),
      received_get_involved_flags.pluck(:user_id)
    ].flatten.uniq
    User.where(id: user_ids)
  end
end
