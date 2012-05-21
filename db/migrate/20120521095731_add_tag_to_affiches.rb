class AddTagToAffiches < ActiveRecord::Migration
  def change
    add_column :affiches, :tag, :text
  end
end
