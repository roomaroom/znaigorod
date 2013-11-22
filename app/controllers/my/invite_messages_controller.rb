class My::InviteMessagesController < My::ApplicationController
  load_and_authorize_resource

  actions :update, :show, :index

  def index
    index!{
      render partial: "my/invite_messages/invite_messages", layout: false and return if request.xhr?
      render template: 'my/invite_messages/index' and return
    }
  end

  def update
    update! do
      render @invite_message and return
    end
  end

  protected

  def resource
    @invite_message = begin_of_association_chain.received_invite_messages.find(params[:id])
  end

  def collection
    @invite_messages = Kaminari.paginate_array([super, begin_of_association_chain.received_invite_messages].flatten.sort_by(&:created_at).reverse!).page(params[:page]).per(15)
  end

  def begin_of_association_chain
    current_user.account
  end
end
