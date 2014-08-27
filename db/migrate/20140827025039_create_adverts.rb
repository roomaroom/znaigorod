class CreateAdverts < ActiveRecord::Migration
  def change
    create_table :adverts do |t|
      t.string :title
      t.text :description
      t.float :price
      t.text :kind
      t.text :categories
      t.string :phone
      t.integer :account_id
      t.timestamps
    end
  end
end
