User.delete_all
Project.delete_all
Post.delete_all
PostConversant.delete_all
Resource.delete_all
OmniauthAccount.delete_all

@admin = FactoryGirl.create(:user,
  first_name: "Topher",
  last_name: "Hunt",
  email: "hunt.topher@gmail.com",
  password: "password",
  password_confirmation: "password")
@user1 = FactoryGirl.create(:user)
@user2 = FactoryGirl.create(:user)
@user3 = FactoryGirl.create(:user)
5.times { FactoryGirl.create(:user) }

@project1 = FactoryGirl.create(:project, owner: @user1)
@project2 = FactoryGirl.create(:project, owner: @user2)

@post1 = FactoryGirl.create(:published_post, author: @user1)
@post2 = FactoryGirl.create(:published_post, author: @user2)
FactoryGirl.create(:post_conversant, user: @user3, post: @post2)
FactoryGirl.create(:published_post, author: @user3, parent: @post2)
