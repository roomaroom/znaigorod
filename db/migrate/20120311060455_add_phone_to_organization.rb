class AddPhoneToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :phone, :text

  end
end
