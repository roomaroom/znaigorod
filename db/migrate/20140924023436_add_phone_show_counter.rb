class AddPhoneShowCounter < ActiveRecord::Migration
  def up
    add_column :organizations, :phone_show_counter, :integer, default: 0
  end

  def down
    remove_column :organizations, :phone_show_counter
  end
end
