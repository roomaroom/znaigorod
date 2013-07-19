class Manage::AfishasController < Manage::ApplicationController
  defaults :resource_class => Afisha

  custom_actions :resource => :fire_state_event

  has_scope :page, :default => 1
  has_scope :by_state, :only => :index
  has_scope :by_kind, :only => :index

  def create
    create! do |success, failure|
      success.html {
        resource.approve!
        redirect_to manage_afisha_show_path(resource)
      }
      failure.html { render :new }
    end
  end

  def update
    update! do |success, failure|
      success.html {
        redirect_to manage_afisha_show_path(resource)
      }
      failure.html { render :edit }
    end
  end

  def destroy
    destroy! { manage_afisha_index_path }
  end

  def fire_state_event
    fire_state_event! {
      @afisha.fire_state_event params[:event] if @afisha.state_events.include?(params[:event].to_sym)

      redirect_to send("manage_#{@afisha.class.name.underscore}_path", @afisha) and return
    }
  end

  protected

  def collection
    @afisha = params[:include_gone] ? include_gone : only_actual
  end

  def only_actual
    Afisha.search {
      keywords params[:q]
      with :state, params[:by_state] if params[:by_state].present?
      with :kind, params[:by_kind].singularize if params[:by_kind].present?
      paginate paginate_options.merge(:per_page => per_page)

      adjust_solr_params do |params|
        params[:sort] = 'recip(abs(ms(NOW,first_showing_time_dt)),3.16e-11,1,1) desc'
      end

    }.results
  end

  def include_gone
    Afisha.search {
      keywords params[:q]
      with :state, params[:by_state] if params[:by_state].present?
      with :kind, params[:by_kind] if params[:by_kind].present?
      paginate :page => params[:page], :per_page => per_page
    }.results
  end

  alias_method :old_build_resource, :build_resource

  def build_resource
    old_build_resource.tap do |object|
      object.user = current_user
    end
  end
end
