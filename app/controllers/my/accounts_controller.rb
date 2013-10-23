# encoding: utf-8

class My::AccountsController < My::ApplicationController
  skip_authorization_check
  custom_actions :resource => [:destroy_image]

  def edit
    edit!{
      @friends = Kaminari.paginate_array(@account.friends.approved.map(&:friendable)).page(1).per(5)
    }
  end

  def update
    update!{ redirect_to my_root_path and return }
  end

  def show
    @feeds_presenter = FeedsPresenter.new(params.merge({:account_id => current_user.account.id}))
  end

  protected

  def resource
    @account ||= current_user.account
  end
end
