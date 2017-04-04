class PostConversant < ActiveRecord::Base
  belongs_to :user
  belongs_to :post

  validates :intention, presence: true, length: { maximum: 255 }
end
