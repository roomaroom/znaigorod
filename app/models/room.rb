class Room < ActiveRecord::Base
  belongs_to :context, :polymorphic => true
  attr_accessible :capacity, :context_id, :context_type, :description, :feature, :rooms_count, :title

  include PresentsAsCheckboxes

  presents_as_checkboxes :feature#,
    #validates_presence: true,
    #message: I18n.t('activerecord.errors.messages.at_least_one_value_should_be_checked')
end
