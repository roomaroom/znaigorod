desc 'Actualize discounts'
task :actualize_discounts => :environment do
  Discount.actual.map(&:index)
  Sunspot.commit
end
