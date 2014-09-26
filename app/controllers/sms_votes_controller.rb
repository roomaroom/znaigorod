class SmsVotesController < ApplicationController
  def index
    contest = Contest.where(sms_prefix: params[:prefix]).first
    secret = contest.sms_secret.encode('utf-8') + params[:txt].encode('utf-8') + params[:tid].encode('utf-8') + params[:date].encode('utf-8')
    md5_secret = Digest::MD5.new
    md5_secret.update secret

    if md5_secret.hexdigest == params[:sid]
      work = contest.works.where(code: params[:txt].to_i).first
      work.sms_votes.create(vote_date: params[:date], sid: params[:sid], sms_text: params[:txt], sms_id: params[:tid],prefix: params[:prefix] ) if work
    end
    render text: 'sms'
  end
end
