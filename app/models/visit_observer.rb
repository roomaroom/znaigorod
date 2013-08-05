# encoding: utf-8

class VisitObserver < ActiveRecord::Observer
  def after_create(visit)
    if visit.visitable.is_a?(Afisha) && visit.visitable.user.present?
      visit.messages.create(account: visit.visitable.user.account, producer_id: visit.user.account_id, kind: :user_visit_afisha)
    end
  end
end
