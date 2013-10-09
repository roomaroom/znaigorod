# encoding: utf-8

class VisitObserver < ActiveRecord::Observer
  def after_create(visit)
    Feed.create(
      :feedable => visit,
      :account => visit.user.account,
      :created_at => visit.created_at,
      :updated_at => visit.updated_at
    )
    if visit.visitable.is_a?(Afisha) && visit.visitable.user.present? && visit.user != visit.visitable.user
      NotificationMessage.delay(:queue => 'critical').create(
        account: visit.visitable.user.account,
        producer: visit.user.account,
        kind: :user_visit_afisha,
        messageable: visit)
    end
  end
end
