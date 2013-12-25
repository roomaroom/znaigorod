# encoding: utf-8

class PostObserver < ActiveRecord::Observer
  def after_to_published(post, transition)
    if post.account.present?
      MyMailer.delay(:queue => 'mailer').mail_new_published_post(post) unless post.account.is_admin?
      Feed.create(:feedable => post, :account => post.account, :created_at => post.created_at, :updated_at => post.updated_at)
    end
  end

  def after_to_draft(post, transition)
    if post.account.present?
      NotificationMessage.delay(:queue => 'critical').create(
        :account => post.account,
        :kind => :post_returned,
        :messageable => post) unless post.account.is_admin?
    end
  end
end
