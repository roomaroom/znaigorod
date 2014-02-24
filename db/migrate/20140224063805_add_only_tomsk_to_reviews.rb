class AddOnlyTomskToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :only_tomsk, :boolean

    Review.update_all :only_tomsk => false
  end
end
