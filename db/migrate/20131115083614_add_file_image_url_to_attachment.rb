require 'progress_bar'

class AddFileImageUrlToAttachment < ActiveRecord::Migration
  def up
    add_column :attachments, :file_image_url, :string

    puts 'Setting new gallery fields. Please wait...'

    bar = ProgressBar.new(Account.count)

    Account.all.each do |account|
      if account.gallery_images.any?
        account.gallery_images.each do |image|
          image.file_image_url = image.file_url
          image.save!
        end
      end
      bar.increment!
    end

    Rake::Task['account:get_social_avatars'].invoke

  end

  def down
    remove_column :attachments, :file_image_url
  end
end
