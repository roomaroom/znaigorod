# encoding: utf-8

class Comment < ActiveRecord::Base
  attr_accessible :ancestry, :body, :parent_id

  belongs_to :user
  has_one :account, through: :user
  belongs_to :commentable, :polymorphic => true

  has_ancestry
  has_many :votes, :as => :voteable, :dependent => :destroy
  has_many :messages, :as => :messageable, :dependent => :destroy
  has_one :feed, :as => :feedable, :dependent => :destroy

  scope :rendereable,      -> { where(:commentable_type => ['Afisha', 'Organization']) }

  def child
    Comment.where(:ancestry => self.id.to_s)
  end

  normalize_attribute :body, :ancestry
  validates_presence_of :body
  validate :authenticated_user

  def name
    user ? account.title : 'неизвестный автор'
  end

  def avatar
    user ?  account.avatar : Account.new.avatar
  end

  auto_html_for :body do
    html_escape
    simple_format
    znaigorod_link :target => "_blank", :rel => 'nofollow'
  end

  private

    def authenticated_user
      errors.add :body, 'Комментарии могут оставлять только зарегистрированные пользователи' if user.nil?
    end

end

# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  commentable_id   :integer
#  commentable_type :string(255)
#  body             :text
#  ancestry         :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

