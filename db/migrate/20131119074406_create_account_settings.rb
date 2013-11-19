class CreateAccountSettings < ActiveRecord::Migration

  def up
    create_table :account_settings do |t|
      t.references :account
      t.timestamps
    end

    add_index :account_settings, :account_id
    add_column :account_settings, :personal_invites, :boolean, default: true
    add_column :account_settings, :personal_messages, :boolean, default: true
    add_column :account_settings, :comments_to_afishas, :boolean, default: true
    add_column :account_settings, :comments_to_discounts, :boolean, default: true
    add_column :account_settings, :comments_answers, :boolean, default: true
    add_column :account_settings, :comments_likes, :boolean, default: true
    add_column :account_settings, :afishas_statistics, :boolean, default: true
    add_column :account_settings, :discounts_statistics, :boolean, default: true

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
