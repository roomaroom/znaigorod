class MembersController < ApplicationController
  inherit_resources

  load_and_authorize_resource

  actions :index, :create

  belongs_to :discount, :optional => true

  has_scope :page, :default => 1

  layout false

  def index
    index! {
      @members = parent.members.page(params[:page]).per(3)
      render :partial => 'members', :locals => { :members => @members } and return }
  end

  def create
    create! {
      @members = parent.members.page(params[:page]).per(3)
      render :partial => 'members', :locals => { :members => @members } and return
    }
  end

  protected

  def build_resource
    super.account = current_user.account if current_user

    @member
  end
end
