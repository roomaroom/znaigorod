class SmsVote < ActiveRecord::Base
  attr_accessible :vote_date, :sid, :sms_text, :sms_id, :prefix
  belongs_to :work

  after_create :increment_sms_counter

  def increment_sms_counter
    work.increment(:sms_counter)
    work.agree = '1'
    work.save
  end
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

