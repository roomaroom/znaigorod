class NewCategory < ActiveRecord::Migration
  def up
    Review.all.each do |review|
      if review.categories.include?(:accidents)
        review.categories << :crash
        review.categories.delete(:accidents)
        review.save
      end
    end

    to_other=[:cafe, :culture, :family, :informative]

    Review.all.each do |review|
      to_other.each do |other|
        if review.categories.include?(other)
          review.categories << :other
          review.categories.delete(other)
          review.save
        end
      end
    end
  end
end
