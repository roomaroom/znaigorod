class AddAfishaIdAndOrganizationIdToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :afisha_id, :integer
    add_column :reviews, :organization_id, :integer
    add_index :reviews, :afisha_id
    add_index :reviews, :organization_id
  end
end
