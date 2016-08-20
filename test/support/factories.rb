FactoryGirl.define do
  factory(:user) do
    name { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
    email { "#{name.downcase.gsub(/[^\w]+/, '_')}@example.com" }
    password              "password"
    password_confirmation "password"
  end

  factory(:project) do
    association :owner, factory: :user
    title { Faker::Lorem.words(4).join(" ") }
    subtitle { Faker::Lorem.words(7).join(" ") }
    stage "idea"
  end

  factory(:draft_post, class: :Post) do
    association :author, factory: :user
    title { Faker::Lorem.words(5).join(" ") }
    intention_type "share news"
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
    intention_type "seek_perspectives"
    intention_statement { Faker::Lorem.sentence }
  end
end
