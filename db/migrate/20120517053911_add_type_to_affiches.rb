class AddTypeToAffiches < ActiveRecord::Migration
  def change
    add_column :affiches, :type, :string
  end
end
