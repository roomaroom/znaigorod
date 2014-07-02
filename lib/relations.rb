module Relations
  extend ActiveSupport::Concern

  included do
    has_many :relations, :as => :master, :dependent => :destroy
  end

  module ClassMethods
    def has_relations_with(*types)
      types.each do |type|
        has_many "related_#{type.to_s.pluralize}", :through => :relations, :source => :slave, :source_type => type.to_s.classify
      end
    end
  end
end

