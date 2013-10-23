# encoding: utf-8

class My::FriendsController < My::ApplicationController
  inherit_resources
  load_and_authorize_resource

  actions :index
  custom_actions resource: :change_friendship

  has_scope :page, :default => 1

  def index
    index! {
      @presenter = AccountsPresenter.new(params)
      @account = AccountDecorator.new Account.find(current_user.account.id)
      @friends = Kaminari.paginate_array(@account.friends.approved.map(&:friendable)).page(params[:page]).per(15)

      render partial: 'friends/account_friends', :locals => { :collection => @friends }, layout: false and return if request.xhr?
      render 'friends/index' and return
    }
  end

  def change_friendship
    raise CanCan::AccessDenied unless current_user
    parent = Account.find(params["account_id"])
    @friend = current_user.account.friendly_for(parent).first || current_user.account.friends.create(friendable: parent)
    @friend.change_friendship
    render :text => '', :status => 200 and return if request.xhr?

    redirect_to my_account_friends_path
  end
end
