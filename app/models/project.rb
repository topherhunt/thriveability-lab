class Project < ActiveRecord::Base
  belongs_to :owner, class_name: :User
  has_many :resources, as: :target
  has_many :received_like_flags, as: :target
  has_many :received_stay_informed_flags, as: :target
  has_many :received_get_involved_flags, as: :target

  # See https://github.com/mbleigh/acts-as-taggable-on#usage
  acts_as_taggable_on :tags
  acts_as_taggable_on :needs

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
  validates :quadrant_ul, length: { maximum: 255 }
  validates :quadrant_ur, length: { maximum: 255 }
  validates :quadrant_ll, length: { maximum: 255 }
  validates :quadrant_lr, length: { maximum: 255 }
  validates :call_to_action, length: { maximum: 255 }
  validates :stage, inclusion: { in: ["idea", "developing", "mature"] }
end
