class AddAllowExternalLinksToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :allow_external_links, :boolean
  end
end
