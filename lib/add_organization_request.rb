class AddOrganizationRequest
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :title, :address, :phone

  validates_presence_of :title, :address, :phone

  def initialize(attributes = {})
    attributes.each { |name, value| send "#{name}=", value }
  end

  def persisted?
    false
  end
end
