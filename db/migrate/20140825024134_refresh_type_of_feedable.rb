class RefreshTypeOfFeedable  < ActiveRecord::Migration
  def up
    feedable_types = Feed.pluck(:feedable_type).uniq
    review_types = ['review_article', 'review_photo', 'review_video']

    (feedable_types - ['Review', 'Comment']).each do |type|
      Feed.where(:feedable_type => type).update_all :type_of_feedable => type.underscore
    end

    Feed.where(:feedable_type => 'Review').each do |feed|
      feed.type_of_feedable = feed.feedable.class.name.underscore
      feed.type_of_feedable = 'review' if review_types.include? feed.type_of_feedable
      feed.save
    end

    Feed.where(:feedable_type => 'Comment').each do |feed|
      feed.type_of_feedable = feed.feedable.is_answer? ? 'question' : 'comment'
      feed.save
    end
  end

  def down
  end
end
