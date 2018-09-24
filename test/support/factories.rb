include ActionDispatch::TestProcess

FactoryGirl.define do
  factory(:user) do
    first_name { Faker::Name.first_name.gsub("'", "") }
    last_name  { Faker::Name.last_name.gsub("'", "")  }
    email      { "#{full_name.downcase.gsub(/[^\w]+/, '_')}@example.com" }
    password              "password"
    password_confirmation "password"
    # These are overkill for most test users, but useful in the dev environment
    tagline      { Faker::Lorem.words(rand(2..12)).join(" ").capitalize }
    bio_interior { Faker::Lorem.sentences(rand(2..10)).join(" ") }
    bio_exterior { Faker::Lorem.sentences(rand(2..10)).join(" ") }
    created_at   { (rand * 400.0).days.ago }
    confirmed_at { created_at + (rand * 10).hours }
    current_sign_in_at { (rand * 30).days.ago }
  end

  factory(:project) do
    association :owner, factory: :user
    title        { Faker::Lorem.words(3).join(" ").capitalize }
    subtitle     { Faker::Lorem.words(10).join(" ").capitalize }
    desired_impact { Faker::Lorem.sentences(rand(1..4)).join(" ") }
    contribution_to_world { Faker::Lorem.sentences(rand(1..4)).join(" ") }
    location_of_home { Faker::Lorem.words(rand(2..3)).join(" ") }
    location_of_impact { Faker::Lorem.words(rand(2..3)).join(" ") }
    image { fixture_file_upload(Rails.root.join('test', 'fixtures', 'test.png'), 'image/png') }
    stage        { Project::STAGES.sample }
    tag_list     { PredefinedTag::PRESETS.sample(rand(1..3)).join(",") }
    created_at   { (rand * 400.0).days.ago }
  end

  factory(:draft_post, class: :Post) do
    association :author, factory: :user
    title         { Faker::Lorem.words(5).join(" ").capitalize }
    draft_content { Gibberish.random_paragraphs(rand(1..5)) }
    tag_list      { PredefinedTag::PRESETS.sample(rand(0..3)) if parent.nil? and parent_id.nil? }
    created_at    { (rand * 400.0).days.ago }

    factory(:published_post) do
      draft_content nil
      published_content { Gibberish.random_paragraphs(rand(1..5)) }
      published true
      published_at { created_at + (rand * 24).hours }
    end
  end

  factory(:post_conversant) do
    association :post
    association :user
    intention  { Post::INTENTION_PRESETS.take(8).sample }
    created_at { (rand * 400.0).days.ago }
  end

  factory(:resource) do
    association :creator, factory: :user
    title           { Faker::Lorem.words(rand(2..15)).join(" ").capitalize }
    source_name     { Faker::Lorem.words(rand(1..5)).join(" ").capitalize }
    current_url     { Faker::Internet.url }
    description     { Faker::Lorem.sentences(rand(1..5)).join(" ") }
    tag_list        { PredefinedTag::PRESETS.sample(rand(0..3)) }
    media_type_list { Resource::DEFAULT_MEDIA_TYPES.sample(rand(0..3)).first }
    created_at      { (rand * 400.0).days.ago }
  end

  factory(:like_flag) do
    association :user
    target { raise "Target must be specified!" }
  end

  # It doesn't make sense to create factories for Events and Notifications.
  # For these, just use Event.register or ActiveRecord#create.
end
