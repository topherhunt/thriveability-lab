module Services
  class FindOrCreateUserFromAuth < BaseService
    def call(auth:)
      # Auth hash format: https://github.com/omniauth/omniauth/wiki/Auth-Hash-Schema
      raise "Expected auth.uid to be present!" unless auth.uid.present?
      raise "Unknown provider #{auth.provider}" unless auth.provider == "auth0"
      uid = auth.uid || raise("UID is required")

      if user = User.find_by(auth0_uid: uid)
        log :info, "Authed known user #{user.id} (uid: #{uid}, name: #{user.name})"
        user
      else
        name = auth.info.name || raise("Name is required")
        image_url = auth.info.image
        user = User.new(auth0_uid: uid, name: name, image: image_url)
        ensure_image_filename(user, image_url)
        user.save!
        log :info, "Authed new user #{user.id} (uid: #{uid}, name: #{user.name})"
        user
      end
    rescue => e
      raise "Invalid auth data: #{e}. The full auth data from Auth0: #{auth.to_json}"
    end

    def ensure_image_filename(user, image_url)
      if image_url.present? && user.image_file_name.blank?
        filename = image_url.match(/[^\/]+\z/)[0]
        log :warn, "Paperclip failed to parse filename from image url #{image_url.inspect}, defaulting to #{filename.inspect}."
        user.image_file_name = filename
      end
    end
  end
end
