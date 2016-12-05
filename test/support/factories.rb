FactoryGirl.define do
  factory(:user) do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name  }
    email { "#{full_name.downcase.gsub(/[^\w]+/, '_')}@example.com" }
    password              "password"
    password_confirmation "password"
    # These are overkill for most test users, but useful in the dev environment
    self_dreams              { Faker::Lorem.sentence }
    self_passions            { Faker::Lorem.sentence }
    self_skills              { Faker::Lorem.sentence }
    self_proud_traits        { Faker::Lorem.sentence }
    self_weaknesses          { Faker::Lorem.sentence }
    self_evolve              { Faker::Lorem.sentence }
    self_looking_for         { Faker::Lorem.sentence }
    self_work_at             { Faker::Lorem.sentence }
    self_professional_goals  { Faker::Lorem.sentence }
    self_fields_of_expertise { Faker::Lorem.sentence }
    confirmed_at 1.week.ago
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

  factory(:resource) do
    title { Faker::Lorem.words(5).join(" ").capitalize }
    url { Faker::Internet.url }
    description { Faker::Lorem.paragraph }
  end
end
