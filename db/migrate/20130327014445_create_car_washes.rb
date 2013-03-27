class CreateCarWashes < ActiveRecord::Migration
  def change
    create_table :car_washes do |t|
      t.text :category
      t.references :organization
      t.string :title
      t.text :description

      t.timestamps
    end
    add_index :car_washes, :organization_id
  end
end
