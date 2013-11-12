# encoding: utf-8

desc "This task takes emails from our db.user > omniauth fileds and write them into the account email fields"
task :get_emails_from_omniauth => :environment do
  puts "I am taking emails and putting them on their places. Please wait."

  counter = 0

  User.all.each do |user|
    account = user.account
    if user.present? and account.present? and account.email.nil? and user.email.present?
      account.email = user.email
      account.save!
    end
  end

end

