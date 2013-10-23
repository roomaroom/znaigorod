module DraftPublishedStates
  extend ActiveSupport::Concern

  included do
    scope :available_for_edit,    -> { where(:state => [:draft, :published]) }
    scope :by_kind,               ->(kind) { where(:kind => kind) }
    scope :by_state,              ->(state) { where(:state => state) }
    scope :draft,                 -> { with_state(:draft) }
    scope :published,             -> { with_state(:published) }

    state_machine :initial => :draft do
      after_transition any => :published do |afisha, transition|
        afisha.send(:set_slug)
        Feed.feeds_for_state_machine(afisha)
      end

      after_transition :from => :published do |afisha, transition|
        afisha.feed.destroy if afisha.feed
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
