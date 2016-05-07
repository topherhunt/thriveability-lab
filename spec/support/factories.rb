FactoryGirl.define do
  factory(:user) do
    sequence(:email) { |n| "test_user_#{n}@example.com" }
    password              "foobar01"
    password_confirmation "foobar01"
    sequence(:first_name) { |n| "Firstname#{n}" }
    sequence(:last_name) { |n| "Lastname#{n}" }
  end

  factory(:project) do
    association :owner, factory: :user
    sequence(:title) { |n| "Project (#{n})" }
    subtitle "Subtitle"
    stage "idea"
  end

  factory(:post) do
    association :author, factory: :user
    sequence(:title) { |n| "Post (#{n})" }
    content "Test post content"
    intention_type "share news"
    published true
    published_at 1.day.ago
  end
end
