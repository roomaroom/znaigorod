class AddWithRelationsToTeaser < ActiveRecord::Migration
  def change
    add_column :teasers, :with_relations, :boolean
  end
end
