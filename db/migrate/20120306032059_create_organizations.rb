class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.text :title
      t.text :category
      t.text :payment
      t.text :cuisine
      t.text :feature
      t.text :site
      t.text :email
      t.text :description
      t.timestamps
    end
  end
end
