class AddCommentToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :comment, :text
  end
end
