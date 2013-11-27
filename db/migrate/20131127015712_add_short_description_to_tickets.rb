class AddShortDescriptionToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :short_description, :string
  end
end
