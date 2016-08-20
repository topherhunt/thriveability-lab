@admin = FactoryGirl.create(:user,
  name: "Topher Hunt",
  email: "hunt.topher@gmail.com",
  password: "foobar01",
  password_confirmation: "foobar01")
@user1 = FactoryGirl.create(:user)
@user2 = FactoryGirl.create(:user)
@user3 = FactoryGirl.create(:user)

@project1 = FactoryGirl.create(:project, owner: @user1)
@project2 = FactoryGirl.create(:project, owner: @user2)

@post1 = FactoryGirl.create(:published_post, author: @user1)
@post2 = FactoryGirl.create(:published_post, author: @user2)
FactoryGirl.create(:post_conversant, user: @user3, post: @post2)
FactoryGirl.create(:published_post, author: @user3, parent: @post2)
