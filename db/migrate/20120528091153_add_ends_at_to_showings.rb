class AddEndsAtToShowings < ActiveRecord::Migration
  def change
    add_column :showings, :ends_at, :datetime
  end
end
