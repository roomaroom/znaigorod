class AddPublishedAtToAfisha < ActiveRecord::Migration
  def change
    add_column :afisha, :published_at, :datetime

    Afisha.where(state: 'published').each do |afisha|
      afisha.published_at = afisha.updated_at
    end
  end
end
