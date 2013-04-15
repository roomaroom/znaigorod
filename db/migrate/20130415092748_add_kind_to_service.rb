class AddKindToService < ActiveRecord::Migration
  def change
    add_column :services, :kind, :string
  end
end
