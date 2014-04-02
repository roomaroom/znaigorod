class CreatePromotions < ActiveRecord::Migration
  def change
    create_table :promotions do |t|
      t.string :url

      t.timestamps
    end
  end
end
