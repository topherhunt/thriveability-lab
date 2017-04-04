class Post < ActiveRecord::Base
  INTENTION_PRESETS = [
    "share an update about world events, research, or objective knowledge",
    "share a personal experience, insight, or perspective on an issue",
    "raise awareness of a problem",
    "propose a solution to a problem",
    "learn about others' perspectives",
    "critique a perspective so we can all learn and grow",
    "seek advice",
    "offer advice",
    "- other -"
  ]

  belongs_to :author, class_name: :User, inverse_of: :posts
  has_many :post_conversant_joins, class_name: :PostConversant
  has_many :conversants, through: :post_conversant_joins, source: :user
  has_many :received_like_flags, class_name: 'LikeFlag', as: :target
  has_many :received_stay_informed_flags, class_name: 'StayInformedFlag', as: :target

  has_closure_tree # tree hierarchy - see https://github.com/mceachen/closure_tree

  # See https://github.com/mbleigh/acts-as-taggable-on#usage
  acts_as_taggable_on :tags

  validates :author,    presence: true
  validates :title,     length: { maximum: 255 }
  validates :intention, length: { maximum: 255 }
  validates :title,     presence: true, if: :root_and_published?
  validates :intention, presence: true, if: :root_and_published?
  validates :published_content, presence: true, if: :published?

  # The `published` column is somewhat redundant (if published, then published_content will be NOT NULL) but a boolean is much more efficient to query I think.
  scope :published, ->{ where published: true }
  scope :inline, ->{ where "reply_at_char_position IS NOT NULL" }
  scope :not_inline, ->{ where "reply_at_char_position IS NULL" }
  scope :visible_to, ->(user){ where("author_id = ? OR published = TRUE", user.try(:id) || 0) }
  scope :not_roots, ->{ where "parent_id IS NOT NULL" }

  def self.most_popular
    # TODO: Unperformant
    published.roots.sort_by{ |p| -p.received_like_flags.count }.take(5)
  end

  private

  def root_and_published?
    root? and published?
  end
end
