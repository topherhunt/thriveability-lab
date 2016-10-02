class User < ActiveRecord::Base
  has_many :omniauth_accounts, dependent: :delete_all
  has_many :projects, foreign_key: :owner_id
  # TODO: This can be renamed to just `resources`; the risk of confusion is low
  has_many :created_resources, class_name: :Resource, foreign_key: :creator_id, inverse_of: :creator
  has_many :posts, foreign_key: :author_id, inverse_of: :author
  has_many :like_flags # as the originator
  has_many :stay_informed_flags

  # Include default devise modules. Others available are: :lockable, :timeoutable
  devise :registerable, :confirmable, :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable,
         omniauth_providers: [:facebook, :google_oauth2, :linkedin]

  # See https://github.com/thoughtbot/paperclip#quick-start
  has_attached_file :image, styles: { medium: "300x300#", thumb: "100x100#" },
    default_url: "/missing_user.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  validates :self_passions, length: { maximum: 1000 }
  validates :self_skills, length: { maximum: 1000 }
  validates :self_proud_traits, length: { maximum: 1000 }
  validates :self_weaknesses, length: { maximum: 1000 }
  validates :self_evolve, length: { maximum: 1000 }
  validates :self_dreams, length: { maximum: 1000 }
  validates :self_looking_for, length: { maximum: 1000 }
  validates :self_work_at, length: { maximum: 1000 }
  validates :self_professional_goals, length: { maximum: 1000 }
  validates :self_fields_of_expertise, length: { maximum: 1000 }

  before_save :update_has_set_password

  # TODO: Move this to a Handler class
  def self.find_or_create_or_link_from_omniauth(auth:, logged_in_user: nil)
    found_account = OmniauthAccount.find_by(provider: auth.provider, uid: auth.uid)
    if logged_in_user
      if found_account
        # A user is logged in, and the social account is linked to another user.
        # Merge that other linked user record into the logged-in user record.
        found_account.user.merge!(to_user: logged_in_user)
        logged_in_user
      else
        # A user is logged in, and this social account isn't in our system yet.
        # Link the social account.
        logged_in_user.create_omniauth_account(auth)
        logged_in_user
      end
    else
      if found_account
        # No user is logged in, but we found a user based on this social account.
        found_account.user
      else
        if found_user = User.find_by(email: auth.info.email)
          # This social account's email matches a user registered in our system.
          # Link to that user rather than create a new one.
          found_user.omniauth_accounts.where(provider: auth.provider).delete_all
          found_user.create_omniauth_account(auth)
          found_user.update!(confirmed_at: Time.now.utc) if found_user.confirmed_at.nil?
          found_user
        else
          # This social account isn't in our system, and we have no record of its
          # email address. Create a new user and link the social account.
          new_user = User.create!(
            email: auth.info.email,
            password: Devise.friendly_token, # random throw-away password
            name: auth.info.name,
            image: auth.info.image,
            confirmed_at: Time.now.utc,
            has_set_password: false)
          new_user.create_omniauth_account(auth)
          new_user
        end
      end
    end
  end

  # TODO: Move this to a Handler class
  def merge!(to_user:)
    return if to_user.id == self.id

    unless User.reflect_on_all_associations.map(&:name).to_set == [:omniauth_accounts, :created_resources, :posts, :like_flags, :stay_informed_flags].to_set
      raise "ERROR: Refusing to perform .merge!, it looks like I've forgotten to set up additional associations."
    end

    omniauth_accounts.update_all(user_id: to_user.id)
    created_resources.update_all(creator_id: to_user.id)
    posts.update_all(author_id: to_user.id)
    like_flags.update_all(user_id: to_user.id)
    stay_informed_flags.update_all(user_id: to_user.id)
    self.destroy!
  end

  def create_omniauth_account(auth)
    omniauth_accounts.create!(provider: auth.provider, uid: auth.uid)
  end

  def update_has_set_password
    if persisted? and encrypted_password_changed? and ! has_set_password?
      self.has_set_password = true
    end
  end
end
