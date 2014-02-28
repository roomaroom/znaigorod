class PonominaluTicketObserver < ActiveRecord::Observer
  def after_save(ticket)
    ticket.afisha.delay.reindex_showings
  end
end
