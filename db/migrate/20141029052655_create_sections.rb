class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :title
      t.belongs_to :organization
      t.timestamps
    end
  end
end
