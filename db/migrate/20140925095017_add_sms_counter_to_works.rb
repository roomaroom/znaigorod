class AddSmsCounterToWorks < ActiveRecord::Migration
  def change
    add_column :works, :sms_counter, :integer, :default => 0
  end
end
