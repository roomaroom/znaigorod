module DraftPublishedStates
  extend ActiveSupport::Concern

  included do
    scope :available_for_edit,    -> { where(:state => [:draft, :published]) }

    state_machine :initial => :draft do
      after_transition any => :published do |afisha, transition|
        afisha.send(:set_slug)
      end

      event :to_published do
        transition :draft => :published
      end

      event :to_draft do
        transition :published => :draft
      end

      state :published do
        validates_presence_of :showings, :if => Proc.new { |record| record.is_a?(Afisha) && !record.movie? && !record.affiche_schedule.present? }
      end
    end
  end

end
