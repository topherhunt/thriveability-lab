class Conversation < ApplicationRecord
  include Searchable

  # See https://github.com/mbleigh/acts-as-taggable-on#usage
  acts_as_taggable_on :tags

  belongs_to :creator, class_name: "User"
  has_many :comments, as: :context
  has_many :participant_joins, class_name: "ConversationParticipantJoin"
  has_many :participants, through: :participant_joins

  validates :creator_id, presence: true
  validates :title, presence: true, length: {maximum: 255}

  def self.latest(n)
    order("created_at DESC").limit(n)
  end

  def self.most_popular(n)
    # TODO: What happens if you join the same assoc multiple times?
    joins(:comments)
      .group("conversations.id")
      .order(Arel.sql("COUNT(comments.id) DESC"))
      .limit(n)
  end

  def to_elasticsearch_document
    {
      full_text_primary: [title].join(" "),
      full_text_secondary: [tag_list, creator.name, comments.pluck(:body)].join(" ")
    }
  end

  def participant?(user)
    participants.where(id: user.id).any?
  end
end
