require 'spec_helper'

describe AccountSettings do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: account_settings
#
#  id                    :integer          not null, primary key
#  personal_invites      :boolean          default(TRUE)
#  personal_messages     :boolean          default(TRUE)
#  comments_to_afishas   :boolean          default(TRUE)
#  comments_to_discounts :boolean          default(TRUE)
#  comments_answers      :boolean          default(TRUE)
#  comments_likes        :boolean          default(TRUE)
#  afishas_statistics    :boolean          default(TRUE)
#  discounts_statistics  :boolean          default(TRUE)
#  account_id            :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  dating                :boolean          default(TRUE)
#

