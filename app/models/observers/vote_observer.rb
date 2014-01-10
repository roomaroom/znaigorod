# encoding: utf-8

class VoteObserver < ActiveRecord::Observer
  def after_create(vote)
    if vote.voteable.is_a?(Afisha) && vote.voteable.user.present? && vote.user.present? && vote.voteable.user != vote.user
      NotificationMessage.delay(:queue => 'critical').create(
        account: vote.voteable.user.account,
        producer: vote.user.account,
        kind: :user_vote_afisha,
        messageable: vote)
    elsif vote.voteable.is_a?(Comment) && vote.user.present? && vote.voteable.user != vote.user
      if vote.voteable.user.account.email.present? && vote.voteable.user.account.account_settings.comments_likes
        NoticeMailer.delay(:queue => 'mailer', :retry => false).comment_like(vote)
      end
      NotificationMessage.delay(:queue => 'critical').create(
        account: vote.voteable.user.account,
        producer: vote.user.account,
        kind: :user_vote_comment,
        messageable: vote)
    end
  end

  def after_save(vote)
    if vote.like && vote.user.present?
      Feed.create(
        :feedable => vote,
        :account => vote.user.account,
      )
    else
      vote.feed.destroy if vote.feed
    end
  end

end
