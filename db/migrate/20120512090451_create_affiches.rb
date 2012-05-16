class CreateAffiches < ActiveRecord::Migration
  def change
    create_table :affiches do |t|
      t.string :title

      t.timestamps
    end
  end
end
