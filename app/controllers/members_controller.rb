class MembersController < ApplicationController
  inherit_resources

  load_and_authorize_resource

  actions :create, :destroy

  belongs_to :discount, :optional => true

  layout false

  def create
    create! { render :partial => 'members', :locals => { :memberable => parent } and return }
  end

  def destroy
    destroy! { render :partial => 'members', :locals => { :memberable => parent } and return }
  end

  protected

  def build_resource
    super.account = current_user.account if current_user

    @member
  end
end
