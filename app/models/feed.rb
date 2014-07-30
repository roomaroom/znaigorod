class Feed < ActiveRecord::Base
  attr_accessible :feedable, :account, :created_at, :updated_at
  belongs_to :feedable, :polymorphic => true
  belongs_to :account

  scope :discount_or_member,  -> {where("feedable_type = 'Member' OR feedable_type = 'Discount'")}

  searchable do
    string(:feedable_type) { feedable.class.name.underscore }
    integer(:account_id)
  end

  def self.feeds_for_presenter(searcher_params)
    if searcher_params[:feedable_type] == 'Discount'
      result = self.search do
        with :account_id, searcher_params[:account_id]
      end
      #searcher_params.delete(:feedable_type)
      #self.discount_or_member.where(searcher_params).includes(:feedable).order('created_at DESC')
    else
      #self.where(searcher_params).includes(:feedable).order('created_at DESC')
      result = self.search do
        with :account_id, searcher_params[:account_id]
        with :feedable_type, searcher_params[:feedable_type]
      end
    end
    result.results
  end

end

# == Schema Information
#
# Table name: feeds
#
#  id            :integer          not null, primary key
#  feedable_id   :integer
#  feedable_type :string(255)
#  account_id    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

