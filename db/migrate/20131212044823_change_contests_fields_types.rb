class ChangeContestsFieldsTypes < ActiveRecord::Migration
  def up
    change_column :contests, :starts_on, :datetime
    rename_column :contests, :starts_on, :starts_at
    change_column :contests, :ends_on, :datetime
    rename_column :contests, :ends_on, :ends_at
  end

  def down
    rename_column :contests, :ends_at, :ends_on
    change_column :contests, :ends_on, :date
    rename_column :contests, :starts_at, :starts_on
    change_column :contests, :starts_on, :date
  end
end
