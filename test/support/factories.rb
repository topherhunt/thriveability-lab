include ActionDispatch::TestProcess

FactoryBot.define do
  factory(:user) do
    auth0_uid    { "google-oauth2|fakeuser-" + SecureRandom.hex }
    name         { Faker::Name.name.gsub("'", "") }
    email        { "#{name.downcase.gsub(/[^\w]+/, '_')}@example.com" }
    # These are overkill for most tests, but useful in the dev seeded db
    tagline      { Faker::Lorem.words(rand(2..12)).join(" ").capitalize }
    location     { Faker::LordOfTheRings.location }
    created_at   { (rand * 400.0).days.ago }
    last_signed_in_at { (rand * 30).days.ago }
  end

  factory(:user_profile_prompt) do
    association :user
    stem { Faker::Lorem.words(3).join(" ").capitalize }
    response { Faker::Lorem.words(10).join(" ") }
  end

  factory(:project) do
    association :owner, factory: :user
    title        { Faker::Lorem.words(3).join(" ").capitalize }
    subtitle     { Faker::Lorem.words(10).join(" ").capitalize }
    desired_impact { Faker::Lorem.sentences(rand(1..4)).join(" ") }
    contribution_to_world { Faker::Lorem.sentences(rand(1..4)).join(" ") }
    location_of_home { Faker::Lorem.words(rand(2..3)).join(" ") }
    location_of_impact { Faker::Lorem.words(rand(2..3)).join(" ") }
    image { fixture_file_upload("#{Rails.root}/test/fixtures/test.png", 'image/png') }
    stage        { Project::STAGES.sample }
    tag_list     { PredefinedTag::PRESETS.sample(rand(1..3)).join(",") }
    created_at   { (rand * 400.0).days.ago }
  end

  factory(:conversation) do
    association :creator, factory: :user
    title { Faker::Lorem.words(5).join(" ").capitalize }
    tag_list { PredefinedTag::PRESETS.sample(rand(0..3)) }
  end

  factory(:comment) do
    context { raise "context must be specified!" }
    association :author, factory: :user
    body { Gibberish.random_paragraphs(rand(1..5)) }
  end

  factory(:conversation_participant_join) do
    association :conversation
    association :participant, factory: :user
    intention { Faker::Lorem.words(rand(2..15)).join(" ").capitalize }
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
