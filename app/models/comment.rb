class Comment < ApplicationRecord
  VALID_CONTEXTS = ["Conversation", "Project", "Resource"]

  belongs_to :context, polymorphic: true
  belongs_to :author, class_name: "User"

  validates :context_type, presence: true, inclusion: {in: VALID_CONTEXTS}
  validates :context_id, presence: true
  validates :author_id, presence: true
  validates :body, presence: true, length: {maximum: 2000}

  after_create :reindex_context
  after_update :reindex_context
  after_destroy :reindex_context

  def self.latest(n)
    order("created_at DESC").limit(n)
  end

  def reindex_context
    context.update_es_document
  end
end
