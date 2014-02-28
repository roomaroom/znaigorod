class CreatePonominaluTickets < ActiveRecord::Migration
  def change
    create_table :ponominalu_tickets do |t|
      t.references :afisha
      t.string :ponominalu_id
      t.integer :count

      t.timestamps
    end
    add_index :ponominalu_tickets, :afisha_id
  end
end
