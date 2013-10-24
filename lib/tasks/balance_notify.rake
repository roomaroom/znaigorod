task :balance_notify => :environment do
  Organization.available_suborganization_classes.each do |klass|
    klass.joins(:reservation).where("reservations.phone IS NOT NULL AND reservations.balance <= ?", Settings['sms_claim.warning']).each do |suborganization|
      reservation = suborganization.reservation

      sms = Sms.new do |sms|
        sms.phone = reservation.phone
        sms.message = "На вашем счете осталось #{reservation.balance} руб."
        sms.smsable = reservation
      end

      sms.save!
    end
  end
end
