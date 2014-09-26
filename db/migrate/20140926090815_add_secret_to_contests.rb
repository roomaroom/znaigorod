class AddSecretToContests < ActiveRecord::Migration
  def change
    add_column :contests, :sms_secret, :string
  end
end
