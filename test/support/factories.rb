FactoryGirl.define do
  factory(:user) do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name  }
    email { "#{full_name.downcase.gsub(/[^\w]+/, '_')}@example.com" }
    password              "password"
    password_confirmation "password"
    # These are overkill for most test users, but useful in the dev environment
    bio_interior { Faker::Lorem.sentence }
    bio_exterior { Faker::Lorem.sentence }
    confirmed_at 1.week.ago
    current_sign_in_at 3.days.ago
  end

  factory(:project) do
    association :owner, factory: :user
    title { Faker::Lorem.words(3).join(" ").capitalize }
    subtitle { Faker::Lorem.words(7).join(" ").capitalize }
    stage "idea"
  end

  factory(:draft_post, class: :Post) do
    association :author, factory: :user
    title { Faker::Lorem.words(5).join(" ").capitalize }
    intention "share news"
    draft_content { Faker::Lorem.paragraph }

    factory(:published_post) do
      draft_content nil
      published_content { Faker::Lorem.paragraph }
      published true
      published_at 1.day.ago
    end
  end

  factory(:post_conversant) do
    association :post
    association :user
    intention "seek perspectives"
  end

  factory(:resource) do
    association :creator, factory: :user
    title { Faker::Lorem.words(5).join(" ").capitalize }
    source_name { Faker::Name.first_name }
    current_url { Faker::Internet.url }
    description { Faker::Lorem.paragraph }
  end

  factory(:like_flag) do
    association :user
    target { raise "Target must be specified!" }
  end
end
