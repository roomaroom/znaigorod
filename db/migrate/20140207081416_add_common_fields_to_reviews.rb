class AddCommonFieldsToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :content, :text
    add_column :reviews, :slug, :string
    add_column :reviews, :status, :string
    add_column :reviews, :tag, :text
    add_column :reviews, :categories, :text
    add_column :reviews, :state, :string
    add_column :reviews, :account_id, :integer
  end
end
