class Post < ActiveRecord::Base
  belongs_to :author, class_name: :User, inverse_of: :posts

  # See https://github.com/mbleigh/acts-as-taggable-on#usage
  acts_as_taggable_on :tags

  validates_presence_of :author
  validates_presence_of :title
  validates_presence_of :content
  validates_presence_of :intention_type

  validates :title, length: { maximum: 255 }
  validates :intention_type, inclusion: { in: ["share news", "share facts", "share perspective", "raise awareness", "seek perspectives", "seek advice", "other"] }
  validates :intention_statement, length: { maximum: 255 }

  def publish!
    self.published = true
    self.published_at = Time.now
    save!
  end
end
