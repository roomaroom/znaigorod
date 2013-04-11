# encoding: utf-8

class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, :polymorphic => true
  attr_accessible :ancestry, :body, :parent_id
  has_ancestry

  normalize_attribute :body, :ancestry
  validates_presence_of :body
  validate :authenticated_user

  delegate :name, :avatar, :profile, :to => :user, :prefix => true, :allow_nil => true

  def name
    user ? user_name : 'неизвестный автор'
  end

  def avatar
    user && user_avatar ? user_avatar : User.new.avatar
  end

  private
    def authenticated_user
      errors.add :body, 'Комментарии могут оставлять только зарегистрированные пользователи' if user.nil?
    end
end
