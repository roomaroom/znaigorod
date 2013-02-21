class CreateSocialLinks < ActiveRecord::Migration
  def change
    create_table :social_links do |t|
      t.references :organization
      t.text :title
      t.text :url

      t.timestamps
    end
    add_index :social_links, :organization_id
  end
end
