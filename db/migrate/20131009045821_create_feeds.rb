class CreateFeeds < ActiveRecord::Migration
  def up
    create_table :feeds do |t|
      t.references :feedable, :polymorphic => true
      t.references :account

      t.timestamps
    end

    add_index :feeds, :feedable_id
    add_index :feeds, :account_id

    %w[comment vote visit].each do |model|
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

    %w[invitation].each do |model|
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

  end

  def down
    remove_index :feeds, :feedable_id
    remove_index :feeds, :account_id
    drop_table :feeds
  end
end
