class Manage::FunniesController < Manage::ApplicationController
  actions :all, :except => :show

  has_scope :page, :default => 1

  protected
    def build_resource
      super

      (1..7).each do |day|
        resource.schedules.build(:day => day)
      end unless resource.schedules.any?

      resource.build_address unless resource.address

      resource
    end
end
