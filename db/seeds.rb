Notification.delete_all
Event.delete_all
Message.delete_all
User.delete_all
Project.delete_all
Post.delete_all
PostConversant.delete_all
Resource.delete_all
LikeFlag.delete_all
StayInformedFlag.delete_all
GetInvolvedFlag.delete_all
OmniauthAccount.delete_all

@users = []
@projects = []
@posts = []
@resources = []

@topher = FactoryGirl.create(:user,
  first_name: "Topher",
  last_name: "Hunt",
  email: "hunt.topher@gmail.com"
)

puts "\nCreating 50 users..."
50.times do |i|
  print "."
  # first_name = Faker::Name.first_name
  # last_name = Faker::Name.last_name
  # email = "#{first_name}.#{last_name}@example.com".downcase.gsub(/[^\w\@\.]/, '')
  # location = Faker::LordOfTheRings.location

  uri = URI.parse('https://randomuser.me/api/')
  response = Net::HTTP.get_response(uri)
  json = JSON.parse(response.body)['results'].first

  user = FactoryGirl.create(:user, {
    email: json['email'].gsub(/\s/, ''),
    first_name: json['name']['first'].capitalize,
    last_name: json['name']['last'].capitalize,
    location: json['location']['city'] + ' ' + json['location']['state'],
    image: json['picture']['large']
  })
  @users << user
end
@users = @users.sample(25) + [@topher]

# Make people follow other people first so that they receive notifications of followee activity.
puts "\nPeople following people..."
100.times do |i|
  print "."
  follower = @users.sample
  followee = @users.sample
  # Tolerate failure in case of duplicates
  if StayInformedFlag.create(user: follower, target: followee)
    Event.register(follower, :follow, followee)
  end
end
3.times do |i|
  print "."
  follower = @topher
  followee = @users.sample
  # Tolerate failure in case of duplicates
  if StayInformedFlag.create(user: follower, target: followee)
    Event.register(follower, :follow, followee)
  end
end

puts "\nCreating 25 projects..."
25.times do |i|
  print "."
  user = @users.sample
  # TODO: Add stock images... the lorempixel URL we were using, kept timing out
  project = FactoryGirl.create(:project,
    owner: user,
    image: "https://source.unsplash.com/random/200x200"
  )
  Event.register(project.owner, :create, project)
  @projects << project
end

puts "\nCreating 25 conversations..."
25.times do |i|
  print "."
  post_author = @users.sample
  post = FactoryGirl.create(:published_post, author: post_author)
  Event.register(post_author, :publish, post)
  post_and_children = [post]
  (rand * 10).round.times do
    commenter = @users.sample
    FactoryGirl.build(:post_conversant, user: commenter, post: post).save # may fail
    parent = post_and_children.sample
    comment = FactoryGirl.create(:published_post, author: commenter, parent: parent)
    Event.register(commenter, :publish, comment)
    post_and_children << comment
  end
  @posts << post
end

puts "\nCreating 50 resources..."
50.times do |i|
  print "."
  user = @users.sample
  resource = FactoryGirl.create(:resource,
    creator: user,
    target: [@posts.sample, @projects.sample, nil, nil, nil, nil].sample
  )
  Event.register(user, :create, resource)
  @resources << resource
end

puts "\nAdding like flags..."
150.times do |i|
  print "."
  user = @users.sample
  target = [@users, @posts, @projects, @resources].sample.sample
  # Tolerate failure in case of duplicates
  if LikeFlag.create(user: user, target: target)
    Event.register(user, :like, target)
  end
end

puts "\nPeople follow posts / projects / resources..."
150.times do |i|
  print "."
  user = @users.sample
  target = [@posts, @projects, @resources].sample.sample
  # Tolerate failure in case of duplicates
  if StayInformedFlag.create(user: user, target: target)
    Event.register(user, :follow, target)
  end
end

puts "\nAdding get involved flags..."
100.times do |i|
  print "."
  user = @users.sample
  project = @projects.sample
  # Tolerate failure in case of duplicates
  GetInvolvedFlag.create(user: user, target: project)
end

PredefinedTag.repopulate

puts "\nSeeding complete! Stats:"
puts "- #{User.count} Users"
puts "- #{Project.count} Projects"
puts "- #{Post.count} Posts"
puts "- #{Resource.count} Resources"
