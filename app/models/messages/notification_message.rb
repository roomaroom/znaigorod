# encoding: utf-8

class NotificationMessage < Message
  attr_accessible :account, :body, :state, :kind, :producer, :messageable

  enumerize :kind,
    in: [:new_comment, :reply_on_comment, :afisha_published, :afisha_returned, :afisha_promoted,
         :discount_returned, :user_vote_afisha, :user_vote_comment, :user_visit_afisha,
         :user_add_friend, :auction_bet, :auction_bet_cancel, :auction_bet_approve, :auction_bet_pay,
         :agreed_invite, :disagreed_invite, :offer_approved, :post_returned, :new_answer],
    predicates: true

  scope :unread, -> { where(state: :unread) }
end

# == Schema Information
#
# Table name: messages
#
#  id               :integer          not null, primary key
#  messageable_id   :integer
#  messageable_type :string(255)
#  account_id       :integer
#  producer_id      :integer
#  body             :text
#  state            :string(255)
#  kind             :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  type             :string(255)
#  producer_type    :string(255)
#  invite_kind      :string(255)
#  agreement        :string(255)
#

