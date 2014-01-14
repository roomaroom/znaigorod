class AddColumnsToAccountSettings < ActiveRecord::Migration
  def change
    add_column :account_settings, :personal_digest, :boolean, default: true
    add_column :account_settings, :site_digest, :boolean, default: true
    add_column :account_settings, :statistics_digest, :boolean, default: true

    remove_column :account_settings, :personal_invites
    remove_column :account_settings, :personal_messages
    remove_column :account_settings, :comments_to_afishas
    remove_column :account_settings, :comments_to_discounts
    remove_column :account_settings, :comments_answers
    remove_column :account_settings, :comments_likes
    remove_column :account_settings, :afishas_statistics
    remove_column :account_settings, :discounts_statistics
  end
end
