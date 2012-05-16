class AddFieldsToAffiches < ActiveRecord::Migration
  def change
    add_column :affiches, :description, :text
    add_column :affiches, :poster_url, :string
    add_column :affiches, :trailer_code, :text
  end
end
