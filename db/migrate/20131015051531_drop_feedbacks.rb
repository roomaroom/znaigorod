class DropFeedbacks < ActiveRecord::Migration
  def up
    drop_table :feedbacks
  end

  def down
    create_table :feedbacks do |t|
      t.string :email
      t.text :message
      t.string :fullname

      t.timestamps
    end
  end
end
