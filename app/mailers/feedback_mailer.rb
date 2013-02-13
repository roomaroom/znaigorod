#encoding: utf-8

class FeedbackMailer < ActionMailer::Base
  default :from => Settings['mail']['from']

  def send_email(feedback)
    @feedback = feedback
    mail(:to => Settings['mail']['to'], :subject => 'Обратная связь')
  end
end
