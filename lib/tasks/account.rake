# encoding: utf-8

require 'progress_bar'

namespace :account do

  desc 'Make  everything'

  desc 'Create accounts for users'
  task :create => :environment do
    puts 'Create accounts'
    users = User.ordered
    bar = ProgressBar.new(users.count)
    users.each do |user|
      next if user.account
      user.create_account
      bar.increment!
    end
  end

  desc 'Get friends for account'
  task :get_friends => :environment do
    puts 'Get friends for accounts from socials'
    accounts = Account.ordered
    bar = ProgressBar.new(accounts.count)
    accounts.each do |account|
      account.users.first.get_friends_from_socials if account.users
      bar.increment!
    end
  end

  desc 'Реиндекс аккаунтов для приглашений'
  task :reindex => :environment do
    puts 'Account reindex'
    Account.index
    Sunspot.commit
  end

  desc 'Fix of users avatars 18.11.13'
  task :get_social_avatars => :environment do
    puts 'Get social avatars'
    accounts = Account.includes(:users).where('users.provider = :k1 or users.provider = :k2 or users.provider = :k3', :k1 =>'vkontakte', :k2 => 'twitter', :k3 => 'facebook').where('accounts.avatar_file_name is null')
    bar = ProgressBar.new(accounts.count)
    accounts.each do |account|
      account.get_social_avatar
      bar.increment!
    end

  end

end
