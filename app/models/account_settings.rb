class AccountSettings < ActiveRecord::Base
  belongs_to :account
  attr_accessible :personal_invites, :personal_messages, :comments_to_afishas, :comments_to_discounts, :comments_answers, :comments_likes, :afishas_statistics, :discounts_statistics, :account, :created_at, :updated_at

end
