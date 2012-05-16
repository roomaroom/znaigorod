class AddStartsOnAndEndsOnToAffiches < ActiveRecord::Migration
  def change
    add_column :affiches, :starts_on, :date
    add_column :affiches, :ends_on, :date
  end
end
