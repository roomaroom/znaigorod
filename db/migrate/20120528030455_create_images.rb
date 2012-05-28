class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.text :url
      t.references :organization

      t.timestamps
    end

    add_index :images, :organization_id
  end
end
