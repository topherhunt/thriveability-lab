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

@topher = FactoryGirl.create(:user,
  first_name: "Topher",
  last_name: "Hunt",
  email: "hunt.topher@gmail.com"
)

puts "\nCreating 100 users..."
@users = 100.times.map do |i|
  print "."
  uri = URI.parse('https://randomuser.me/api/')
  response = Net::HTTP.get_response(uri)
  json = JSON.parse(response.body)['results'].first
  begin
    params = {
      email: json['email'].gsub(/\s/, ''),
      first_name: json['name']['first'].capitalize,
      last_name: json['name']['last'].capitalize,
      image: json['picture']['large'],
      location: json['location']['city'] + ' ' + json['location']['state']
    }
    FactoryGirl.create(:user, params)
  rescue => e
    puts "Failed to create user from params: #{params}. The error: #{e}. Skipping."
  end
end.compact

@users = @users.sample(50) + [@topher]

puts "\nCreating 80 projects..."
@projects = 80.times.map do |i|
  print "."
  FactoryGirl.create(:project,
    owner: @users.sample
    # TODO: Add stock images... the lorempixel URL we were using, kept timing out
  )
end

puts "\nCreating 50 conversations..."
@posts = 50.times.map do |i|
  print "."
  post = FactoryGirl.create(:published_post, author: @users.sample)
  post_and_children = [post]
  10.times do
    user = @users.sample
    FactoryGirl.build(:post_conversant, user: user, post: post).save # failure is OK
    post_and_children << FactoryGirl.create(:published_post,
      author: user,
      parent: post_and_children.sample
    )
  end
  post
end

puts "\nCreating 100 resources..."
@resources = 100.times.map do |i|
  print "."
  FactoryGirl.create(:resource,
    creator: @users.sample,
    target: [@posts.sample, @projects.sample, nil, nil, nil, nil].sample
  )
end

puts "\nAdding like flags..."
300.times do |i|
  print "."
  # Tolerate failure in case of duplicates
  LikeFlag.create(
    user: @users.sample,
    target: [@users, @posts, @projects, @resources].sample.sample
  )
end

puts "\nAdding follow flags..."
200.times do |i|
  print "."
  # Tolerate failure in case of duplicates
  StayInformedFlag.create(
    user: @users.sample,
    target: [@users, @posts, @projects, @resources].sample.sample
  )
end

puts "\nAdding get involved flags..."
50.times do |i|
  print "."
  # Tolerate failure in case of duplicates
  GetInvolvedFlag.create(user: @users.sample, target: @projects.sample)
end

PredefinedTag.repopulate

puts "\nSeeding complete! Stats:"
puts "- #{User.count} Users"
puts "- #{Project.count} Projects"
puts "- #{Post.count} Posts"
puts "- #{Resource.count} Resources"
