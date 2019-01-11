namespace :auth do
  desc "List force-login URLs for the 10 most recent users"
  task list_force_logins: :environment do
    User.order("last_signed_in_at DESC").limit(10).each do |user|
      puts "* http://#{ENV.fetch("HOSTNAME")}/auth/force_login/#{user.id}?password=#{ENV.fetch("FORCE_LOGIN_PASSWORD")} (#{user.email})"
    end
  end
end
