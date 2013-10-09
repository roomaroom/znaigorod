class Manage::WebcamsController < Manage::ApplicationController

  actions :all

  has_scope :ordered, :type => :boolean, :default => true

  after_filter :reset_cache, :only => [:create, :update]

  protected

  def reset_cache
    expire_fragment('all_available_webcams') if @webcam.errors.empty?
  end

end
