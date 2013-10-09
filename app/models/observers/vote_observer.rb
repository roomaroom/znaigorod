# encoding: utf-8

class VoteObserver < ActiveRecord::Observer
  def after_create(vote)
    Feed.create(
      :feedable => vote,
      :account => vote.user.account,
      :created_at => vote.created_at,
      :updated_at => vote.updated_at
    )
    if vote.voteable.is_a?(Afisha) && vote.voteable.user.present? && vote.user.present? && vote.voteable.user != vote.user
      NotificationMessage.delay(:queue => 'critical').create(
        account: vote.voteable.user.account,
        producer: vote.user.account,
        kind: :user_vote_afisha,
        messageable: vote)
    elsif vote.voteable.is_a?(Comment) && vote.voteable.user != vote.user
      NotificationMessage.delay(:queue => 'critical').create(
        account: vote.voteable.user.account,
        producer: vote.user.account,
        kind: :user_vote_comment,
        messageable: vote)
    end
  end
end
