class SmsVotesController < ApplicationController
  def index
    File.open('getmvote.txt', 'w') { |f| f.write(params) }
    render text: 'sms'
  end
end
