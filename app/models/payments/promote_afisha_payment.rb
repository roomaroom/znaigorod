class PromoteAfishaPayment < Payment
  def approve!
    super
    promote_afisha
  end

  default_value_for :amount, Settings['promote_afisha.price'] || 50.0

  private

  alias :afisha :paymentable

  def promote_afisha
    afisha.promoted_at = Time.zone.now
    afisha.showings.map(&:index!)
  end
end
