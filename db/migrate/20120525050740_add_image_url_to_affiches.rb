class AddImageUrlToAffiches < ActiveRecord::Migration
  def change
    add_column :affiches, :image_url, :string
  end
end
