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
