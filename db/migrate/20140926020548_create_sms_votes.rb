class CreateSmsVotes < ActiveRecord::Migration
  def change
    create_table :sms_votes do |t|
      t.datetime :vote_date
      t.text :sid
      t.string :sms_text
      t.integer :sms_id
      t.string :prefix
      t.string :phone
      t.integer :work_id
      t.timestamps
    end
  end
end
