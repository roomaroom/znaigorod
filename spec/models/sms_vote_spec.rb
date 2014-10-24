require 'spec_helper'

describe SmsVote do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: sms_votes
#
#  id         :integer          not null, primary key
#  vote_date  :datetime
#  sid        :text
#  sms_text   :string(255)
#  sms_id     :integer
#  prefix     :string(255)
#  phone      :string(255)
#  work_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

