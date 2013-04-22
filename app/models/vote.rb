# encoding: utf-8

class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :voteable, :polymorphic => true
  attr_accessible :like, :user_id

  validate :authenticated_user

  scope :liked, where(:like => true)

  def change_vote
    self.like = (like? ? false : true)
    self.save
  end

  private
    def authenticated_user
      errors.add :like, 'может быть оставлена только зарегистрированным пользователем' if user.nil?
    end
end
