require "test_helper"

class NotificationsTest < Capybara::Rails::TestCase
  test "User activity generates notifications for another user" do
    @user = create(:user)
    @follower = create(:user)
    StayInformedFlag.where(user: @follower, target: @user).create!

    login_as @user
    visit new_project_path
    page.find("#project_title").set("Project Name")
    page.find("#project_subtitle").set("Subtitle Blah")
    select("developing", from: "project[stage]")
    page.find(".save-project-button").click
    assert_equals 1, Project.count
    assert_equals 1, Notification.count
    n = Notification.first
    assert_equals @follower, n.notify_user
    assert_equals "#{@user.full_name} listed the project \"Project Name\"", n.sentence
  end

  test "User can view notifications, mark as read, and view his recent history page" do
    @user = create(:user)
    # Create 60 notifications of various kinds
    20.times do
      project  = create(:project)
      post     = create(:published_post)
      resource = create(:resource)
      add_notification_about project.owner, :created_project, project
      add_notification_about post.author, :published_post, post
      add_notification_about resource.creator, :created_resource, resource
    end

    login_as @user
    assert_selector(".notifications-list .notification.unread", count: 10)
    assert_equals 60, Notification.unread.count
    page.all(".notifications-list .notification.unread a")[4].click
    assert_path post_path(Post.second)
    assert_equals 59, Notification.unread.count
    assert_selector(".notifications-list .notification.unread", count: 9)
    assert_selector(".notifications-list .notification.read", count: 1)
    page.find(".notifications-list a.mark-all-notifications-as-read").click
    assert_path post_path(Post.second) # That link returns you to the same page
    assert_selector(".notifications-list .notification.unread", count: 0)
    assert_selector(".notifications-list .notification.read", count: 10)
    assert_equals 60, Notification.read.count
    page.find(".notifications-list a.see-all-notifications").click
    assert_path notifications_path
    assert_selector(".all-notifications-list .notification.read", count: 50)
  end

  def add_notification_about(actor, action, target)
    @minutes_ago ||= 1
    @minutes_ago += 1
    @user.notifications.create!(actor: actor, action: action, target: target, created_at: @minutes_ago.minutes.ago)
  end
end
