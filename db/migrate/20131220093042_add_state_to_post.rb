class AddStateToPost < ActiveRecord::Migration
  def change
    add_column :posts, :state, :string

    Post.update_all :state => :published
  end
end
