# Conversations and comments.
# TODO: It's probably a code smell that I combined both top-level posts and child
# posts into the same model. Granted closure_tree makes it irresistibly easy to do so.
class Post < ActiveRecord::Base
  INTENTION_PRESETS = [
    "share about facts, events, or objective knowledge",
    "share about a personal experience or perspective",
    "raise awareness of a problem",
    "propose a solution to a problem",
    "learn about others' perspectives",
    "critique a perspective",
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
  scope :published,  ->{ where published: true }
  scope :draft,      ->{ where published: false }
  scope :inline,     ->{ where "reply_at_char_position IS NOT NULL" }
  scope :not_inline, ->{ where "reply_at_char_position IS NULL" }
  scope :visible_to, ->(user){ where("author_id = ? OR published = TRUE", user.try(:id) || 0) }
  scope :not_roots,  ->{ where "parent_id IS NOT NULL" }
  scope :published_since, ->(datetime){ where("published_at >= ?", datetime) }

  after_save :touch_root

  def self.most_popular
    # TODO: Unperformant
    published.roots.sort_by{ |p| -p.received_like_flags.count }.take(5)
  end

  def self.most_active(n)
    # Should return: Conversations with the most comments in the past month
    # Once the site gets more traffic, we can narrow this to the past week
    SafeCacher.cache("#{n}_most_active_posts", expires_in: 30.minutes) {
      # Recent published top-level posts
      # Sorted by the # of recent comments
      Post.published.roots
        .all_recent_or_latest(n)
        .sort_by { |post| -post.descendants.published_since(1.month.ago).count }
        .take(n)
    }
  end

  def self.all_recent_or_latest(n)
    if where("updated_at > ?", 1.month.ago).count >= n
      where("updated_at > ?", 1.month.ago)
    else
      order("updated_at DESC").limit(n)
    end
  end

  def author_and_conversants
    ([author] + conversants)
      .uniq
      .compact # remove any errant nils (from cached posts, etc.)
  end

  private

  def root_and_published?
    root? and published?
  end

  def touch_root
    return if root?
    return if root.updated_at > 1.day.ago
    root.update!(updated_at: Time.current)
  end
end
