class Post < ActiveRecord::Base
  belongs_to :author, class_name: :User, inverse_of: :posts
  has_many :post_conversant_joins, class_name: :PostConversant
  has_many :conversants, through: :post_conversant_joins, source: :user

  has_closure_tree # tree hierarchy - see https://github.com/mceachen/closure_tree

  # See https://github.com/mbleigh/acts-as-taggable-on#usage
  acts_as_taggable_on :tags

  validates :author, presence: true
  validate :require_title_if_root
  validates :title, length: { maximum: 255 }
  validates :intention_type, presence: true, inclusion: { in: IntentionType.all.map(&:short) }
  validates :intention_statement, length: { maximum: 255 }
  validates :content, presence: true

  scope :published, ->{ where published: true }
  scope :inline, ->{ where "reply_at_char_position IS NOT NULL" }
  scope :not_inline, ->{ where "reply_at_char_position IS NULL" }

  private

  def require_title_if_root
    if title.blank? and root?
      errors.add(:title, "can't be blank")
    end
  end
end
