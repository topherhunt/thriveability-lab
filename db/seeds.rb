Notification.delete_all
Event.delete_all
Message.delete_all
Project.delete_all
Comment.delete_all
ConversationParticipantJoin.delete_all
Conversation.delete_all
Resource.delete_all
LikeFlag.delete_all
StayInformedFlag.delete_all
GetInvolvedFlag.delete_all
OmniauthAccount.delete_all
User.delete_all

unless ENV["ANNICK_WARNED"].present? or Rails.env.development?
  raise "Warn Annick first!"
end

@users = []
@projects = []
@conversations = []
@resources = []

@topher = FactoryGirl.create(:user,
  first_name: "Topher",
  last_name: "Hunt",
  email: "hunt.topher@gmail.com"
)

SCALE=1 # default: 5

puts "\nCreating users..."
(SCALE*10).times do |i|
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
(SCALE*20).times do |i|
  print "."
  follower = @users.sample
  followee = @users.sample
  # Tolerate failure in case of duplicates
  if StayInformedFlag.create(user: follower, target: followee)
    Event.register(follower, :follow, followee)
  end
end
SCALE.times do |i|
  print "."
  follower = @topher
  followee = @users.sample
  # Tolerate failure in case of duplicates
  if StayInformedFlag.create(user: follower, target: followee)
    Event.register(follower, :follow, followee)
  end
end

puts "\nCreating projects..."
(SCALE*5).times do |i|
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

puts "\nCreating conversations..."
(SCALE*5).times do |i|
  print "."
  convo_creator = @users.sample
  convo = FactoryGirl.create(:conversation, creator: convo_creator)
  Event.register(convo_creator, :create, convo)
  rand(1..10).times do
    commenter = @users.sample
    comment = FactoryGirl.create(:comment, context: convo, author: commenter)
    ConversationParticipantJoin.where(conversation: convo, participant: commenter).first ||
      FactoryGirl.create(:conversation_participant_join, conversation: convo, participant: commenter)
    Event.register(commenter, :comment, convo)
  end
  @conversations << convo
end

puts "\nCreating resources..."
(SCALE*10).times do |i|
  print "."
  user = @users.sample
  resource = FactoryGirl.create(:resource,
    creator: user,
    target: [@conversations.sample, @projects.sample, nil, nil, nil, nil].sample
  )
  Event.register(user, :create, resource)
  @resources << resource
end

puts "\nAdding like flags..."
(SCALE*20).times do |i|
  print "."
  user = @users.sample
  target = [@users, @conversations, @projects, @resources].sample.sample
  # Tolerate failure in case of duplicates
  if LikeFlag.create(user: user, target: target)
    Event.register(user, :like, target)
  end
end

puts "\nPeople follow conversations / projects / resources..."
(SCALE*20).times do |i|
  print "."
  user = @users.sample
  target = [@conversations, @projects, @resources].sample.sample
  # Tolerate failure in case of duplicates
  if StayInformedFlag.create(user: user, target: target)
    Event.register(user, :follow, target)
  end
end

puts "\nAdding get involved flags..."
(SCALE*5).times do |i|
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
puts "- #{Conversation.count} Conversations"
puts "- #{Resource.count} Resources"
