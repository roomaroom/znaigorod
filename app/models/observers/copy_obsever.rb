# encoding: utf-8

class CopyObserver < ActiveRecord::Observer
  def after_save(copy)
    case copy.copyable
    when Ticket
       copy.copyable.afisha.delay.reindex_showings
    when Discount
      copy.copyable.delay.index
    end
  end
end
