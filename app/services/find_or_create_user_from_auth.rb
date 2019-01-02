module Services
  class FindOrCreateUserFromAuth < BaseService
    def call(auth:)
      # See https://github.com/omniauth/omniauth/wiki/Auth-Hash-Schema
      raise "Expected auth.uid to be present!" unless auth.uid.present?
      uid = auth.uid || raise("UID is required")
      name = get_name(auth) || raise("Name is required")
      email = auth.info.email || raise("Email is required")
      image_url = auth.info.image || raise("Expected image to always be present")

      if user = User.find_by(auth0_uid: uid)
        log :info, "Authed known user (id: #{user.id}, uid: #{uid}, name: #{user.name})"
        user
      else
        user = User.new(auth0_uid: uid, name: name, email: email, image: image_url)
        ensure_image_filename(user, image_url)
        user.save!
        log :info, "Authed new user (id: #{user.id}, uid: #{uid}, "\
          "name: #{user.name}, email: #{user.email})"
        user
      end
    rescue => e
      raise "Invalid auth data: #{e}. The full auth data from Auth0: #{auth.to_json}"
    end

    def get_name(auth)
      # The Auth0 database connection sets `name` to the email address, weirdly
      if auth.info.name.include?("@")
        auth.info.nickname
      else
        auth.info.name
      end
    end

    def ensure_image_filename(user, image_url)
      # Work around a weird Paperclip bug where the filename gets blanked out
      if image_url.present? && user.image_file_name.blank?
        filename = image_url.match(/[^\/]+\z/)[0]
        log :warn, "Paperclip failed to parse filename from image url #{image_url.inspect}, defaulting to #{filename.inspect}."
        user.image_file_name = filename
      end
    end
  end
end
