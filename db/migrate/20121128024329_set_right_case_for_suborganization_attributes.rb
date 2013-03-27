class SetRightCaseForSuborganizationAttributes < ActiveRecord::Migration
  def up
    Organization.available_suborganization_classes.each do |model|
      next unless ActiveRecord::Base.connection.table_exists?(model.name.underscore.pluralize)

      puts model.name
      pb = ProgressBar.new(model.count)

      model.find_each do |record|
        record.update_attributes! :category => (record.category || '').split(',').map(&:squish).map(&:mb_chars).map(&:capitalize).join(', ') if record.has_attribute?(:category)
        record.update_attributes! :cuisine  => (record.cuisine || '').split(',').map(&:squish).map(&:mb_chars).map(&:capitalize).join(', ')  if record.has_attribute?(:cuisine)
        record.update_attributes! :offer    => (record.offer || '').split(',').map(&:squish).map(&:mb_chars).map(&:downcase).join(', ')      if record.has_attribute?(:offer)
        record.update_attributes! :feature  => (record.feature || '').split(',').map(&:squish).map(&:mb_chars).map(&:downcase).join(', ')    if record.has_attribute?(:feature)

        pb.increment!
      end
    end
  end

  def down
  end
end
