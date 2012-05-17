class RemoveStartsOnAndEndsOnFromAffiches < ActiveRecord::Migration
  def up
    remove_column :affiches, :ends_on
    remove_column :affiches, :starts_on
  end

  def down
    add_column :affiches, :starts_on, :date
    add_column :affiches, :ends_on, :date
  end
end
