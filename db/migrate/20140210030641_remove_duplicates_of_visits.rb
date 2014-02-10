class RemoveDuplicatesOfVisits < ActiveRecord::Migration
  def up
    hash = Visit.all.inject({}) do |h, v|
      h["#{v.visitable_type}_#{v.visitable_id}_#{v.user_id}"] ||= 0
      h["#{v.visitable_type}_#{v.visitable_id}_#{v.user_id}"] += 1

      h
    end

    hash.delete_if { |k, v| v < 2  }

    hash.each do |key, value|
      visitable_type = key.split('_').first
      visitable_id = key.split('_').second
      user_id = key.split('_').last

      Visit.where(:visitable_type => visitable_type, :visitable_id => visitable_id, :user_id => user_id)[0..-2].map(&:destroy)
    end
  end

  def down
  end
end
