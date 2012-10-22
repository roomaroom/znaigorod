class AddNonCashToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :non_cash, :boolean
  end
end
