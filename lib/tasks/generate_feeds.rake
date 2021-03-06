# encoding: utf-8

desc "Generating feeds from another models"
task :generate_feeds => :environment do
  puts "Deleting all feeds. Please wait."

  raise "# TODO at first someone should check afisha and discount are published".inspect
  Feed.destroy_all

  %w[member discount].each do |model|
    puts model.capitalize
    items = model.capitalize.constantize.where('account_id IS NOT NULL')
    bar = ProgressBar.new(items.count)
    items.each do |item|
      Feed.create(
        :feedable => item,
        :account => item.account,
        :created_at => item.created_at,
        :updated_at => item.updated_at
      )
      bar.increment!
    end
  end

  %w[comment vote visit afisha].each do |model|
    puts model.capitalize
    items = model.capitalize.constantize.where('user_id IS NOT NULL')
    bar = ProgressBar.new(items.count)
    items.each do |item|
      Feed.create(
        :feedable => item,
        :account => item.user.account,
        :created_at => item.created_at,
        :updated_at => item.updated_at
      )
      bar.increment!
    end
  end

  puts 'Invitation'
  items = Invitation.where('account_id IS NOT NULL AND invited_id IS NULL')
  bar = ProgressBar.new(items.count)
  items.each do |item|
    Feed.create(
      :feedable => item,
      :account => item.account,
      :created_at => item.created_at,
      :updated_at => item.updated_at
    )
    bar.increment!
  end

end

