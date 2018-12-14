class MessagesMailer < ApplicationMailer
  def new_message_received(message)
    @message = message
    mail(to: @message.recipient.email, from: ENV.fetch('SUPPORT_EMAIL'), reply_to: @message.sender.email, subject: "#{app_name}: " + @message.full_subject)
  end

  def new_message_sent(message)
    @message = message
    mail(to: @message.sender.email, from: ENV.fetch('SUPPORT_EMAIL'), subject: "#{app_name}: Your message has been sent to #{@message.recipient.name}")
  end

  def app_name
    "Thrivability Lab"
  end
end
