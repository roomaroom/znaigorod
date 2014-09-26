class SmsVotesController < ApplicationController
  def index
    File.open('getmvote.txt', 'w') { |f| f.write(params) }
    Work.last.sms_votes.create
    render text: 'sms'
  end
end
