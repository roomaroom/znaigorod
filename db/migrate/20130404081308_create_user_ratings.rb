class CreateUserRatings < ActiveRecord::Migration
  def change
    create_table :user_ratings do |t|
      t.references :user
      t.references :organization
      t.integer :value

      t.timestamps
    end
    add_index :user_ratings, :user_id
    add_index :user_ratings, :organization_id
  end
end
