class RenameTicketEmailAddressess < ActiveRecord::Migration
  def up
    rename_column :tickets, :email_addressess, :email_addresses
  end

  def down
    rename_column :tickets, :email_addresses, :email_addressess
  end
end
