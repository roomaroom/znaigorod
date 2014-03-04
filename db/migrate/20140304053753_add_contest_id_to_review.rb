class AddContestIdToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :contest_id, :integer
  end
end
