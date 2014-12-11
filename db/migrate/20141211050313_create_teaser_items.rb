class CreateTeaserItems < ActiveRecord::Migration
  def change
    create_table :teaser_items do |t|
      t.text :text
      t.belongs_to :teaser
      t.timestamps
    end
  end
end
