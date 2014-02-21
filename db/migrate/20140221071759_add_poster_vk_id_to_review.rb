class AddPosterVkIdToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :poster_vk_id, :text
  end
end
