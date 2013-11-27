# encoding: utf-8

class AfishaObserver < ActiveRecord::Observer
  def after_to_published(afisha, transition)
    if afisha.user.present?
      unless afisha.user.is_admin? && afisha.user.email.blank?
        MyMailer.delay(:queue => 'mailer').mail_new_published_afisha(afisha)
      end
      Feed.create(
        :feedable => afisha,
        :account => afisha.user.account,
        :created_at => afisha.created_at,
        :updated_at => afisha.updated_at
      )
    end
  end

  def after_to_draft(afisha, transition)
    afisha.delay.reindex_showings

    if afisha.user.present?
      NotificationMessage.delay(:queue => 'critical').create(
        account: afisha.user.account,
        kind: :afisha_returned,
        messageable: afisha) unless afisha.user.is_admin?
    end
  end

  def before_save(afisha)
    if afisha.published? && afisha.change_versionable?
      afisha.save_version
      MyMailer.delay(:queue => 'mailer').send_afisha_diff(afisha.versions.last) if afisha.versions.last.present?
    end
  end

  def after_save(afisha)
    afisha.delay.reindex_showings

    return unless afisha.published?

    afisha.delay(:queue => 'critical').upload_poster_to_vk if (afisha.poster_vk_id.nil? || afisha.poster_url_changed?) && afisha.poster_url?
  end
end
