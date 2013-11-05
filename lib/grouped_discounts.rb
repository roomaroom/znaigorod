class GroupedDiscounts
  def initialize(collection)
    @discounts = collection
  end

  def grouped
    { nil => [] }.tap do |hash|
      @discounts.each do |discount|
        hash[nil] << discount and next if discount.organizations.empty?

        discount.organizations.each do |organization|
          hash[organization] ||= []
          hash[organization] << discount
        end
      end
    end
  end
end
