class AssociateWorkWithPhotogallery < ActiveRecord::Migration
  def up
    rename_column :works, :contest_id, :context_id
    add_column :works, :context_type, :string
    Work.update_all(:context_type => 'Contest')
  end

  def down
    rename_column :works, :context_id, :contest_id
    remove_column :works, :context_type
  end
end
