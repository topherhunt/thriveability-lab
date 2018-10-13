require "test_helper"

class ConversationTest < ActiveSupport::TestCase
  def set_popularity(target, number)
    LikeFlag.where(target: target).delete_all
    number.times { create :like_flag, target: target }
  end

  test ".most_popular returns the most popular convos" do
    convo1 = create :conversation
    convo2 = create :conversation
    convo3 = create :conversation
    convo4 = create :conversation
    convo5 = create :conversation
    convo6 = create :conversation
    convo7 = create :conversation
    3.times { create :comment, context: convo1 }
    4.times { create :comment, context: convo2 }
    5.times { create :comment, context: convo3 }
    # skip 4 and 5
    2.times { create :comment, context: convo6 }
    1.times { create :comment, context: convo7 }

    expected_results = [convo3, convo2, convo1, convo6, convo7]
    assert_equals expected_results, Conversation.most_popular(5).to_a
  end
end
