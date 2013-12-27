# encoding: utf-8

class CommentObserver < ActiveRecord::Observer
  def after_create(comment)

    create_feed(comment)

    if comment.parent.present? && comment.user != comment.parent.user
      notification_comment_reply(comment)
    end

    if comment.commentable.is_a?(Afisha) && comment.commentable.user && comment.commentable.user != comment.user
      notification_comment_to_afisha(comment)
    end

    if comment.commentable.is_a?(Discount) && comment.commentable.account && comment.commentable.account != comment.account
      notification_comment_to_discount(comment)
    end

  end


  private

  def create_feed(comment)
    Feed.create(
      :feedable => comment,
      :account => comment.user.account,
      :created_at => comment.created_at,
      :updated_at => comment.updated_at
    )
  end

  def notification_comment_reply(comment)
    NotificationMessage.delay(:queue => 'critical').create(
      account: comment.parent.user.account,
      producer: comment.user.account,
      body: comment.body,
      kind: :reply_on_comment,
      messageable: comment)
  end

  def notification_comment_to_afisha(comment)
    NotificationMessage.delay(:queue => 'critical').create(
      account: comment.commentable.user.account,
      producer: comment.user.account,
      body: comment.body,
      kind: :new_comment,
      messageable: comment
    )
  end

  def notification_comment_to_discount(comment)
    NotificationMessage.delay(:queue => 'critical').create(
      account: comment.commentable.account,
      producer: comment.user.account,
      body: comment.body,
      kind: :new_comment,
      messageable: comment
    )
  end

end
