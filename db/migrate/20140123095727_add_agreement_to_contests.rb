class AddAgreementToContests < ActiveRecord::Migration
  def change
    add_column :contests, :agreement, :text
  end
end
