class PositiveActivity < ActiveRecord::Migration
  def up
    add_column :organizations, :positive_activity_date, :datetime

    positive_status = ["talks", "client", "waiting_for_payment"]
    Organization.all.each do |org|
      if org.activities.present?
        if (positive_status.include? org.activities.first.status) && (org.activities.first.state == "completed")
          org.positive_activity_date = org.activities.first.activity_at
          p org.positive_activity_date
          org.save
        end
      end

    end
  end

  def down
    remove_column :organizations, :positive_activity_date
  end
end
