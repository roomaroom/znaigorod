class AddCustomizeForNewWork < ActiveRecord::Migration
  def up
    add_column :contests, :new_work_text, :string, :default => 'Добавить фотографию'
  end

  def down
    remove_column :contests, :new_work_text
  end
end
