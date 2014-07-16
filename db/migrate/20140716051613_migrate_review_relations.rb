class MigrateReviewRelations < ActiveRecord::Migration
  def up
    Review.where('afisha_id IS NOT NULL').each do |review|
      review.relations.create! :slave => review.afisha
    end

    Review.where('organization_id IS NOT NULL').each do |review|
      review.relations.create! :slave => review.organization
    end

    remove_column :reviews, :afisha_id
    remove_column :reviews, :organization_id
  end

  def down
    add_column :reviews, :organization_id, :integer
    add_column :reviews, :afisha_id, :integer
  end
end
