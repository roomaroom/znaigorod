class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :voteable, :polymorphic => true
  attr_accessible :state
  default_value_for :state, false

  validate :authenticated_user

  private
    def authenticated_user
      errors.add :body, 'Комментарии могут оставлять только зарегистрированные пользователи' if user.nil?
    end
end
