class AddPromotedAtToAfisha < ActiveRecord::Migration
  def change
    add_column :afisha, :promoted_at, :datetime
  end
end
