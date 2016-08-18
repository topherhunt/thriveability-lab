class User < ActiveRecord::Base
  has_many :created_resources, class_name: :Resource, foreign_key: :creator_id, inverse_of: :creator
  has_many :posts, foreign_key: :author_id, inverse_of: :author

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :registerable, :confirmable, :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # See https://github.com/thoughtbot/paperclip#quick-start
  has_attached_file :image, styles: { medium: "300x300#", thumb: "100x100#" },
    default_url: "/missing_user.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  # validates :self_passions, length: { maximum: 1000 }
  # validates :self_skills, length: { maximum: 1000 }
  # validates :self_proud_traits, length: { maximum: 1000 }
  # validates :self_weaknesses, length: { maximum: 1000 }
  # validates :self_evolve, length: { maximum: 1000 }
  # validates :self_dreams, length: { maximum: 1000 }
  # validates :self_looking_for, length: { maximum: 1000 }
  # validates :self_work_at, length: { maximum: 1000 }
  # validates :self_professional_goals, length: { maximum: 1000 }
  # validates :self_fields_of_expertise, length: { maximum: 1000 }
end
