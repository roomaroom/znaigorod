class AddBkzLinkToAfisha < ActiveRecord::Migration
  def change
    add_column :afisha, :bkz_link, :text
  end
end
