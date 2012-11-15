class SetPrioritySuborganizationKind < ActiveRecord::Migration
  def up
    Organization.find_each do |organization|
      unless organization.priority_suborganization_kind?
        suborganization = %w[meal entertainment culture].map { |kind| organization.send(kind) }.compact.first

        if suborganization
          priority_suborganization_kind = suborganization.class.name.downcase
          organization.update_attribute :priority_suborganization_kind, priority_suborganization_kind
        end
      end
    end
  end

  def down
    Organization.update_all(:priority_suborganization_kind => nil)
  end
end
