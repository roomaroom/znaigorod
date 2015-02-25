class CreateReviewCategoryItems < ActiveRecord::Migration
  def change
    create_table :review_category_items do |t|
      t.references :organization_category
      t.references :review
      t.timestamps
    end
  end
end
