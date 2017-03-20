class FeedbackMailer < ActionMailer::Base
  default from: "feedback@taernae.net"
  default to: "feedback@taernae.net."

  def new_message(message)
    @message = message

    mail(:subject => "[CocoLog] #{message.subject}")
  end

end
