class CreateCarSalesCenters < ActiveRecord::Migration
  def change
    create_table :car_sales_centers do |t|
      t.text :category
      t.text :description
      t.text :feature
      t.string :title
      t.text :offer
      t.references :organization

      t.timestamps
    end
    add_index :car_sales_centers, :organization_id
  end
end
