class My::DialogsController < My::ApplicationController
  skip_authorization_check

  actions :index, :show

  def index
    @dialogs = Kaminari.paginate_array(current_user.account.dialogs).page(params[:page]).per(15)
    render partial: 'my/dialogs/messages' and return if request.xhr?
  end

  def show
    @dialog_with = Account.find(params[:id])
    @messages = Kaminari.paginate_array(PrivateMessage.dialog_desc(current_user.account.id, @dialog_with.id)).page(params[:page].present? ? params[:page] : 1).per(15)
    @private_message = current_user.account.produced_messages.new(account_id: @dialog_with.id)
    render partial: 'my/dialogs/dialog_messages' and return if params[:page].present?
  end
end
