class MessagesController < ApplicationController
  before_action :require_login

  def new
    @message = Message.new(message_params)
    @recipient = @message.recipient
  end

  def create
    @message = Message.new(message_params)
    @message.sender = current_user

    if @message.save
      @message.send!
      handle_redirect
    else
      flash.now.alert = "Unable to send your message. See error messages below."
      render "new"
    end
  end

  private

  def message_params
    params.require(:message).permit(:recipient_id, :project_id, :subject, :body)
  end

  def handle_redirect
    path = @message.project.present? ? project_path(@message.project) : root_path
    redirect_to path, notice: "Your message has been sent to #{@message.recipient.first_name}!"
  end
end
