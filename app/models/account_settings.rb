class AccountSettings < ActiveRecord::Base

  belongs_to :account
  attr_accessible :personal_digest, :site_digest, :statistics_digest, :dating

  after_save :account_reindex

  def account_reindex
    self.account.index
  end

end

# == Schema Information
#
# Table name: account_settings
#
#  id                :integer          not null, primary key
#  account_id        :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  dating            :boolean          default(TRUE)
#  personal_digest   :boolean          default(TRUE)
#  site_digest       :boolean          default(TRUE)
#  statistics_digest :boolean          default(TRUE)
#

