class UserSubscriptionsMailer < ApplicationMailer
  def send_mail(user, question)
    @greeting = "Hi"
    @question = question
    @answers = question.answers

    mail to: user.email, subject: 'New answer on question'
  end
end
