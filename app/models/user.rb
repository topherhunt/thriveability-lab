class User < ApplicationRecord
  include Searchable

  has_many :projects, foreign_key: :owner_id
  has_many :resources, foreign_key: :creator_id, inverse_of: :creator
  has_many :conversations, foreign_key: "creator_id", inverse_of: :creator
  has_many :comments, foreign_key: "author_id", inverse_of: :author
  has_many :conversation_participant_joins,
    foreign_key: "participant_id",
    inverse_of: :participant
  has_many :participating_in_conversations,
    through: :conversation_participant_joins,
    source: :conversation
  has_many :created_like_flags, class_name: "LikeFlag" # as the originator
  has_many :created_stay_informed_flags, class_name: 'StayInformedFlag'
  has_many :created_get_involved_flags, class_name: 'GetInvolvedFlag'
  has_many :received_like_flags, class_name: 'LikeFlag', as: :target
  has_many :received_stay_informed_flags, class_name: 'StayInformedFlag', as: :target
  has_many :notifications, foreign_key: "notify_user_id"
  has_many :events, foreign_key: "actor_id"
  has_many :profile_prompts, class_name: "UserProfilePrompt"

  has_attached_file :image, styles: { medium: "300x300#", thumb: "100x100#" },
    default_url: "/missing_user.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  # See https://github.com/thoughtbot/paperclip#quick-start
  validates :auth0_uid, presence: true
  validates :name, presence: true, length: {maximum: 255}
  validates :email, presence: true, length: {maximum: 255} # not necessarily unique
  validates :tagline, length: { maximum: 120 }
  validates :location, length: { maximum: 255 }
  validates :bio, length: { maximum: 1000 }
  validates :website_url, length: { maximum: 255 }

  def self.most_recent(n)
    order('last_signed_in_at DESC').limit(n)
  end

  def to_elasticsearch_document
    {
      full_text_primary: [name].join(" "),
      full_text_secondary: [
        tagline, bio, interests, location,
        profile_prompts.map(&:sentence)
      ].join(" ")
    }
  end

  # TODO: Cache this for performance, and figure out when to bust the cache.
  # Maybe this should be a service object that caches and returns the list of interests.
  def interests
    interested_objects = [
      projects.latest(2).includes(:taggings),
      conversations.latest(2).includes(:taggings),
      comments.latest(2).includes(:context).map(&:context),
      resources.latest(2).includes(:taggings),
      created_like_flags.latest(2).where("target_type != 'User'").includes(:target).map(&:target),
      created_stay_informed_flags.latest(2).includes(:target).map(&:target),
      created_get_involved_flags.latest(2).includes(:target).map(&:target),
    ].map(&:to_a).flatten.uniq

    tags_with_counts = interested_objects
      .map { |object| object.try(:tag_list) || [] }
      .flatten
      .inject({}) { |hash, tag| hash[tag] ||= 0; hash[tag] += 1; hash }
      .map { |tag, count| {tag: tag, count: count} }

    tags_with_counts
      .sort_by { |hash| -hash[:count] }
      .take(3)
      .map { |hash| hash[:tag] }
  end
end
