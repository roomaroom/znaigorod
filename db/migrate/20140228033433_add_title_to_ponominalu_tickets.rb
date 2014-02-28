class AddTitleToPonominaluTickets < ActiveRecord::Migration
  def change
    add_column :ponominalu_tickets, :title, :string
  end
end
