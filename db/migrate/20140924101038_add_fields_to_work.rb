class AddFieldsToWork < ActiveRecord::Migration
  def change
    add_column :works, :video_url, :string
    add_column :works, :code, :integer
    add_column :works, :type, :string

    Work.update_all type: 'WorkPhoto'
  end
end
