class RemoveColumnWithRelationsInTeasers < ActiveRecord::Migration
  def change
    remove_column :teasers, :with_relations
  end
end
