class PromoteAfishaPayment < Payment
  def approve!
    super

    promote_afisha
  end

  default_value_for :amount, Settings['promote_afisha.price'] || 50.0

  private

  def payment_system
    :robokassa
  end

  alias :afisha :paymentable

  def promote_afisha
    afisha.update_attributes! :promoted_at => Time.zone.now
  end
end
