class AddPrefixAndShortNumberToContests < ActiveRecord::Migration
  def change
    add_column :contests, :sms_prefix, :string
    add_column :contests, :short_number, :integer
  end
end
