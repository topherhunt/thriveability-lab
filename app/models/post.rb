class Post < ActiveRecord::Base
  belongs_to :author, class_name: :User, inverse_of: :posts

  # See https://github.com/mbleigh/acts-as-taggable-on#usage
  acts_as_taggable_on :tags

  validates_presence_of :author
  validates_presence_of :title, if: :published?
  validates_presence_of :content, if: :published?
  validates_presence_of :intention_type, if: :published?

  validates :title, length: { maximum: 255 }
  validates :intention_type, inclusion: { in: ["share news", "share facts", "share perspective", "raise awareness", "seek perspectives", "seek advice", "other"] }, if: :published?
  validates :intention_statement, length: { maximum: 255 }
end
