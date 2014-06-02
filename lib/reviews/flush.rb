# NOTE: можно будет выпилить после переделывания связки между орг-ями и афишами на многие-ко-многим

module Reviews
  module Flush
    extend ActiveSupport::Concern

    included do
      before_destroy :flush_review

      has_many :reviews
    end

    private

    def flush_review
      attribute = self.class.name.underscore

      reviews.each do |review|
        review.send "#{attribute}=", nil
        review.save!
      end
    end
  end
end
