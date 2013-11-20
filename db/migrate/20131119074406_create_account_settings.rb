class CreateAccountSettings < ActiveRecord::Migration

  def up
    create_table :account_settings do |t|
      t.boolean :personal_invites, default: true
      t.boolean :personal_messages, default: true
      t.boolean :comments_to_afishas, default: true
      t.boolean :comments_to_discounts, default: true
      t.boolean :comments_answers, default: true
      t.boolean :comments_likes, default: true
      t.boolean :afishas_statistics, default: true
      t.boolean :discounts_statistics, default: true
      t.references :account

      t.timestamps
    end

    add_index :account_settings, :account_id

    bar = ProgressBar.new(Account.count)

    Account.all.each do |a|
      a.account_settings = AccountSettings.new
      a.save!
      bar.increment!
    end
  end

  def down
    remove_index :account_settings, :account_id
    drop_table :account_settings
  end

end
