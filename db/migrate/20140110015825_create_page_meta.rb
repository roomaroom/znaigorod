class CreatePageMeta < ActiveRecord::Migration
  def change
    create_table :page_meta do |t|
      t.text :path
      t.text :title
      t.text :header
      t.text :keywords
      t.text :description
      t.text :introduction
      t.text :og_title
      t.text :og_description

      t.timestamps
    end
  end
end
