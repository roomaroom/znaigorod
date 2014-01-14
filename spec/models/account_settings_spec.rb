require 'spec_helper'

describe AccountSettings do
  pending "add some examples to (or delete) #{__FILE__}"
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

