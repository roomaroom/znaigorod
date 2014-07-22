class AddOrganizationMailer < ActionMailer::Base
  default :from => Settings['mail']['from']

  def send_request(request)
    @request = request

    mail :to => 'office@znaigorod.ru', :subject => 'На сайте znaigorod.ru поступил запрос на добавление организации'
  end
end
