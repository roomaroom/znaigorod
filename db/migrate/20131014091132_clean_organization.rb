class CleanOrganization < ActiveRecord::Migration
  def up
    remove_column :organizations, :phone_for_sms
    remove_column :organizations, :balance
  end

  def down
    add_column :organizations, :phone_for_sms, :string
    add_column :organizations, :balance, :float
  end
end
