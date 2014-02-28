class AddRawInfoToPonominaluTickets < ActiveRecord::Migration
  def change
    add_column :ponominalu_tickets, :raw_info, :text
  end
end
