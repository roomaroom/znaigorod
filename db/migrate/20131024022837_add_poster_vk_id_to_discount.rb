class AddPosterVkIdToDiscount < ActiveRecord::Migration
  def change
    add_column :discounts, :poster_vk_id, :text
  end
end
