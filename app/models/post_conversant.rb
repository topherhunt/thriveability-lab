class PostConversant < ActiveRecord::Base
  belongs_to :user
  belongs_to :post

  validates_presence_of :intention_type
  validates_presence_of :intention_statement
end
