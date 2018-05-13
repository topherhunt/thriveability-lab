class Resource < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  __elasticsearch__.index_name "ic-#{Rails.env}-resources"

  DEFAULT_MEDIA_TYPES = ['video', 'lecture', 'audio', 'image', 'book', 'research article', 'in press', 'unpublished', 'essay', 'popular media', 'brochure', 'website', 'course']

  acts_as_taggable_on :tags
  acts_as_taggable_on :media_types

  belongs_to :creator, class_name: :User
  belongs_to :target, polymorphic: true
  has_many :received_like_flags, class_name: 'LikeFlag', as: :target
  has_many :received_stay_informed_flags, class_name: 'StayInformedFlag', as: :target

  scope :latest, ->(n) { order("created_at DESC").limit(n) }

  validates :title, presence: true, length: {maximum: 255}
  validates :description, presence: true, length: {maximum: 1000}
  validates :current_url, length: {maximum: 255}
  validates :source_name, presence: true, length: {maximum: 100}
  validates :relevant_to, length: {maximum: 255}
  validate :require_ownership_if_uploaded

  has_attached_file :attachment
  validates_attachment :attachment, size: { in: 0..10.megabytes }
  do_not_validate_attachment_file_type :attachment

  before_save :ensure_current_url_has_protocol

  def as_indexed_json(options={}) # ElasticSearch integration
    {
      title: title,
      description: description,
      current_url: current_url,
      source_name: source_name,
      tags: tag_list.join(", "),
      media_types: media_type_list.join(", "),
      visible: true
    }
  end

  private

  def require_ownership_if_uploaded
    if attachment.present? and ! ownership_affirmed?
      errors.add(:attachment, "You must verify that you own this file.")
    end
  end

  def ensure_current_url_has_protocol
    self.current_url = "http://#{self.current_url}" unless current_url =~ /^https?\:\/\//
  end
end
