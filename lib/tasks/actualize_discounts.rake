desc 'Actualize discounts'
task :actualize_discounts => :environment do
  discounts = Discount.search { with :actual, true; paginate :page => 1, :per_page => 500 }.results
  pb = ProgressBar.new(discounts.count)

  discounts.each do |discount|
    discount.index
    pb.increment!
  end

  Sunspot.commit
end
