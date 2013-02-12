class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :email
      t.text :message
      t.string :fullname

      t.timestamps
    end
  end
end
