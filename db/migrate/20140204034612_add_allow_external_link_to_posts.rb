class AddAllowExternalLinkToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :allow_external_links, :boolean

    Post.update_all :allow_external_links => false
  end
end
