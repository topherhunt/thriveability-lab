require "test_helper"

class RecentEventTest < ActiveSupport::TestCase
  test "#latest collects data on all projects" do
    project = create :project, created_at: 5.days.ago
    post = create :published_post, created_at: 4.days.ago
    comment = create :published_post, parent: post, created_at: 3.days.ago
    resource = create :resource, created_at: 2.days.ago
    likeflag = create :like_flag, target: comment, created_at: 1.days.ago

    events = RecentEvent.latest(10)
    assert_equals [likeflag.user, resource.creator, comment.author, post.author, project.owner], events.map(&:user)
    # Note that "commenting on a conversation" makes the Post its target
    assert_equals [likeflag.target, resource, post, post, project].map{ |i| [i.class.to_s, i.id] }, events.map(&:target).map{ |i| [i.class.to_s, i.id] }
    assert_equals [:liked_object, :created_resource, :commented_on_post, :published_post, :created_project], events.map(&:action)
  end
end
