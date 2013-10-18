class CreateFeeds < ActiveRecord::Migration
  def up
    create_table :feeds do |t|
      t.references :feedable, :polymorphic => true
      t.references :account

      t.timestamps
    end

    add_index :feeds, :feedable_id
    add_index :feeds, :account_id

    Rake::Task['generate_feeds'].invoke

  end

  def down
    remove_index :feeds, :feedable_id
    remove_index :feeds, :account_id
    drop_table :feeds
  end
end
