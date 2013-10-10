class CreateDiscounts < ActiveRecord::Migration
  def change
    create_table :discounts do |t|
      t.string :title
      t.text :description
      t.text :poster_url
      t.string :type
      t.string :poster_image_file_name
      t.string :poster_image_content_type
      t.integer :poster_image_file_size
      t.datetime :poster_image_updated_at
      t.text :poster_image_url
      t.datetime :starts_at
      t.datetime :ends_at
      t.string :slug
      t.float :total_rating
      t.text :kind
      t.integer :number
      t.integer :origin_price
      t.integer :price
      t.integer :discounted_price
      t.integer :discount
      t.string :payment_system
      t.string :state
      t.references :organization
      t.references :account

      t.timestamps
    end
    add_index :discounts, :organization_id
  end
end
