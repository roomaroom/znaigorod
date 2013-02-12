# encoding: utf-8

class Feedback < ActiveRecord::Base
  attr_accessible :email, :fullname, :message

  validates_presence_of :fullname, :email, :message
  validates_format_of :fullname, :with => /\A([ёЁа-яА-Я]+\s*)+\z/
  validates :email, :email_format => { :message => I18n.t('activerecord.errors.messages.invalid') }

end
