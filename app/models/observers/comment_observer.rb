# encoding: utf-8

class CommentObserver < ActiveRecord::Observer
  def after_create(comment)

    create_feed(comment)

    if comment.parent.present? && comment.user != comment.parent.user
      email_comment_reply(comment)
      notification_comment_reply(comment)
    end

    if comment.commentable.is_a?(Afisha) && comment.commentable.user && comment.commentable.user != comment.user
      email_comment_to_afisha(comment)
      notification_comment_to_afisha(comment)
    end

    if comment.commentable.is_a?(Discount) && comment.commentable.account && comment.commentable.account != comment.account
      email_comment_to_discount(comment)
    end

  end


  private

  def email_comment_to_afisha comment
    account = comment.commentable.user.account
    if account.account_settings.comments_to_afishas && account.email.present?
      NoticeMailer.comment_to_afisha(comment).deliver!
    end
  end

  def email_comment_to_discount comment
    account = comment.commentable.account
    if account.account_settings.comments_to_discounts && account.email.present?
      NoticeMailer.comment_to_discount(comment).deliver!
    end
  end

  def email_comment_reply comment
    account = comment.parent.user.account
    if account.account_settings.comments_answers && account.email.present?
      NoticeMailer.comment_reply(comment).deliver!
    end
  end

  def create_feed comment
    Feed.create(
      :feedable => comment,
      :account => comment.user.account,
      :created_at => comment.created_at,
      :updated_at => comment.updated_at
    )
  end

  def notification_comment_reply comment
      NotificationMessage.delay(:queue => 'critical').create(
        account: comment.parent.user.account,
        producer: comment.user.account,
        body: comment.body,
        kind: :reply_on_comment,
        messageable: comment)
  end

  def notification_comment_to_afisha comment
      NotificationMessage.delay(:queue => 'critical').create(
        account: comment.commentable.user.account,
        producer: comment.user.account,
        body: comment.body,
        kind: :new_comment,
        messageable: comment
      )
  end

end
