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
      user = User.new(auth0_uid: uid, name: name, email: email)
      attach_image(user, image_url) if image_url.present?
      user.save!
      log :info, "Authed new user (id: #{user.id}, uid: #{uid}, "\
        "name: #{user.name}, email: #{user.email})"
      user
    end
  rescue => e
    raise "Invalid auth data: #{e}. The full auth data from Auth0: #{auth.to_json}"
  end

  def get_name(auth)
    # The Auth0 database connection provides the email as "name"
    if match = auth.info.name.match(/\A(.+)\@/)
      match&.captures&.first
    else
      auth.info.name
    end
  end

  # Paperclip isn't smart enough to parse many common image urls. I need to
  # manually download the image, set the encoding, detect the type. Yuck.
  # TODO: Migrate to CarrierWave. (ActiveStorage isn't mature enough yet.)
  def attach_image(user, image_url)
    open(image_url) do |io|
      ext = case io.content_type
      when "image/png" then ".png"
      when "image/jpg" then ".jpg"
      when "image/jpeg" then ".jpg"
      when "image/gif" then ".gif"
      else raise "Don't know how to handle content_type #{io.content_type} for image from url: #{image_url}"
      end
      # Cobbled together from:
      # - https://stackoverflow.com/a/23898725/1729692
      # - https://stackoverflow.com/q/18476985/1729692
      # (Not sure it's safe to assume that encoding will always be ascii-8bit,
      #  but this method reliably blows up if I don't specify encoding)
      tempfile = Tempfile.new(["photo", ext], encoding: "ascii-8bit")
      tempfile.write(io.read)
      tempfile.rewind
      user.image = tempfile # should infer content type & size
      tempfile.close; tempfile.unlink # clean up memory usage
    end
  end
end
