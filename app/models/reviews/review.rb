class Review < ActiveRecord::Base
  attr_accessible :title

  def self.descendant_names
    descendants.map(&:name).map(&:underscore)
  end

  def self.descendant_names_without_prefix
    descendant_names.map { |name| name.gsub prefix, '' }
  end

  def name_without_prefix
    self.class.name.underscore.gsub self.class.prefix, ''
  end

  private

  def self.prefix
    'review_'
  end
end
