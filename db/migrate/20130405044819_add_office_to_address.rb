class AddOfficeToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :office, :string
  end
end
