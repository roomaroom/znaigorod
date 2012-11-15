class AddPrioritySuborganizationToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :priority_suborganization_kind, :string
  end
end
