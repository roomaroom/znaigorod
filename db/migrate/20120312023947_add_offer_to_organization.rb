class AddOfferToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :offer, :text

  end
end
