class AddKindToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :kind, :string
  end
end
