class Resource < ActiveRecord::Base
  belongs_to :creator, class_name: :User, inverse_of: :created_resources

  validates :title, presence: true
  validates :url, presence: true

  has_attached_file :attachment
  validates_attachment :attachment, size: { in: 0..10.megabytes }
  do_not_validate_attachment_file_type :attachment
end
