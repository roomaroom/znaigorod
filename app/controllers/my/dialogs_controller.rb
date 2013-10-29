class My::DialogsController < My::ApplicationController
  skip_authorization_check

  def index
    @dialogs = Kaminari.paginate_array(current_user.account.dialogs).page(params[:page]).per(15)
    render partial: 'my/dialogs/messages', layout: false and return if request.xhr?
    render 'my/dialogs/index' and return
  end

  def show
    @dialog_with = Account.find(params[:id])
    @messages = PrivateMessage.dialog(current_user.account.id, @dialog_with.id).order('id ASC')
    @private_message = current_user.account.produced_messages.new(account_id: @dialog_with.id)
  end
end
