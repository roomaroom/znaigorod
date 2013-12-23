class My::NotificationMessagesController < My::ApplicationController
  skip_authorization_check

  actions :index
  custom_actions :resource => [:change_message_status, :read_all_notifications]

  def index
    index! {
      render partial: "my/messages/messages", locals: { messages: @notification_messages }, layout: false and return if request.xhr?
      render template: 'my/messages/index', locals: { messages: @notification_messages } and return
    }
  end

  def change_message_status
    change_message_status! {
      @notification_message.change_message_status

      render partial: 'my/messages/message', locals: { message: @notification_message } and return
    }
  end

  def read_all_notifications
    NotificationMessage.where(:account_id => current_user.account.id).where(:state => 'unread').each do |notification|
      puts notification.inspect
      notification.state = 'read'
      notification.save!
    end
    render nothing: true
  end

  private

  def collection
    @notification_messages = super.page(params[:page]).per(15)
  end

  def begin_of_association_chain
    current_user.account
  end
end
