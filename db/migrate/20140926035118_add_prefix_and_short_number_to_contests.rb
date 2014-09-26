class AddPrefixAndShortNumberToContests < ActiveRecord::Migration
  def change
    add_column :contests, :prefix, :string
    add_column :contests, :short_number, :integer
  end
end
