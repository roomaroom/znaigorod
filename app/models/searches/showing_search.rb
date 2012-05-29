class ShowingSearch < Search
  attr_accessible :categories,
                  :ends_at_hour_gt,
                  :ends_at_hour_lt,
                  :price_gt,
                  :price_lt,
                  :starts_at_gt,
                  :starts_at_hour_gt,
                  :starts_at_hour_lt,
                  :starts_at_lt,
                  :starts_on_gt,
                  :starts_on_lt,
                  :tags

  attr_accessor :ends_at_hour_gt, :ends_at_hour_lt, :starts_at_hour_gt, :starts_at_hour_lt

  column :categories,         :string
  column :ends_at_hour_gt,    :integer
  column :ends_at_hour_lt,    :integer
  column :price_gt,           :integer
  column :price_lt,           :integer
  column :starts_at_gt,       :datetime
  column :starts_at_hour_gt,  :integer
  column :starts_at_hour_lt,  :integer
  column :starts_at_lt,       :datetime
  column :starts_on_gt,       :date
  column :starts_on_lt,       :date
  column :tags,               :string

  default_value_for(:ends_at_hour_gt)   { DateTime.now.hour }
  default_value_for :price_gt,          0
  default_value_for :starts_at_hour_gt, 0
  default_value_for :starts_at_hour_lt, 24
  default_value_for(:starts_on_gt)      { Date.today }

  protected
    def search_columns
      @showing_search_columns ||= super.reject { |c| c.match(/hour/) }
    end

    def additional_search(search)
      search.any_of do
        all_of do
          with(:starts_at_hour).greater_than(starts_at_hour_gt)
          with(:starts_at_hour).less_than(starts_at_hour_lt)
        end

        all_of do
          with(:ends_at_hour).greater_than(ends_at_hour_gt)
          with(:starts_at_hour).less_than(starts_at_hour_lt)
        end
      end
    end
end

# == Schema Information
#
# Table name: searches
#
#  categories        :string
#  ends_at_hour_gt   :integer
#  ends_at_hour_lt   :integer
#  keywords          :text
#  price_gt          :integer
#  price_lt          :integer
#  starts_at_gt      :datetime
#  starts_at_hour_gt :integer
#  starts_at_hour_lt :integer
#  starts_at_lt      :datetime
#  starts_on_gt      :date
#  starts_on_lt      :date
#  tags              :string
#

