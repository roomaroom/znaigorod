class AddAfishaIdAndOrganizationIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :afisha_id, :integer
    add_column :posts, :organization_id, :integer
  end
end
