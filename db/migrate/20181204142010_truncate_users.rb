class TruncateUsers < ActiveRecord::Migration
  def up
    puts "Destroying all db content..."
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
    User.delete_all
  end
end
