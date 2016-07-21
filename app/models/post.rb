class Post < ActiveRecord::Base
  INTENTION_TYPES = [
    ["share an update about world events", "share news"],
    ["share facts / research / objective knowledge", "share facts"],
    ["share a personal experience or perspective on an issue", "share perspective"],
    ["raise awareness of a problem", "raise awareness"],
    ["learn about others' perspectives", "seek perspectives"],
    ["seek advice", "seek advice"],
    ["critique a perspective", "critique"],
    ["[other]", "other"]]

  belongs_to :author, class_name: :User, inverse_of: :posts
  has_many :post_conversant_joins, class_name: :PostConversant
  has_many :conversants, through: :post_conversant_joins, source: :user

  has_closure_tree # tree hierarchy - see https://github.com/mceachen/closure_tree

  # See https://github.com/mbleigh/acts-as-taggable-on#usage
  acts_as_taggable_on :tags

  validates :author, presence: true
  validates :title, presence: true, length: { maximum: 255 }
  validates :intention_type, presence: true, inclusion: { in: ["share news", "share facts", "share perspective", "raise awareness", "seek perspectives", "seek advice", "other"] }
  validates :intention_statement, length: { maximum: 255 }
  validates :content, presence: true
end
