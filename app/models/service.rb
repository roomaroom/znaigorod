class Service < ActiveRecord::Base
  attr_accessible :age, :title, :feature, :category, :description, :price_attributes

  belongs_to :context, polymorphic: true

  validates_presence_of :title

  alias_attribute :to_s, :title

  has_one :price, dependent: :destroy
  accepts_nested_attributes_for :price, allow_destroy: true

  after_initialize do
    self.price ||= self.build_price()
  end

  delegate :index, to: :context, prefix: true
  after_save :context_index

  normalize_attributes :feature, :title, with: :blank

  scope :filled, -> { where('title IS NOT NULL') }

  include PresentsAsCheckboxes

  presents_as_checkboxes :category,
    validates_presence: true,
    message: I18n.t('activerecord.errors.messages.at_least_one_value_should_be_checked'),
    available_values: []

  presents_as_checkboxes :offer, available_values: []
end

# == Schema Information
#
# Table name: services
#
#  id           :integer          not null, primary key
#  title        :text
#  feature      :text
#  age          :text
#  context_type :string(255)
#  context_id   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  category     :text
#  description  :text
#

