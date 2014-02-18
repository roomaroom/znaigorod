# encoding: utf-8

class ReviewObserver < ActiveRecord::Observer
  def after_to_published(review, transition)
    review.index!

    MyMailer.delay(:queue => 'mailer').mail_new_published_review(review) unless review.account.is_admin?
    Feed.create(:feedable => review, :account => review.account, :created_at => review.created_at, :updated_at => review.updated_at)
  end

  def after_to_draft(review, transition)
    NotificationMessage.delay(:queue => 'critical')
      .create(:account => review.account, :kind => :post_returned, :messageable => review) unless review.account.is_admin?
  end
end
