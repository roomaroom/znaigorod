class AddNewFeedType < ActiveRecord::Migration
  def up
    add_column :feeds, :type_of_feedable, :string

    feedable_types = Feed.pluck(:feedable_type).uniq

    (feedable_types - ['Review', 'Comment']).each do |type|
      Feed.where(:feedable_type => type).update_all :type_of_feedable => type.underscore
    end

    Feed.where(:feedable_type => 'Review').each do |feed|
      feed.type_of_feedable = feed.feedable.class.name.underscore
      feed.save
    end

    Feed.where(:feedable_type => 'Comment').each do |feed|
      feed.type_of_feedable = feed.feedable.is_answer? ? 'question' : 'comment'
      feed.save
    end
  end

  def down
    remove_column :feeds, :type_of_feedable
  end
end
