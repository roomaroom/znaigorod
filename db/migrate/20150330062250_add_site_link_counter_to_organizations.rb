class AddSiteLinkCounterToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :site_link_counter, :integer, :default => 0
  end
end
