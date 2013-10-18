class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_filter :authenticate, :only => [:vkontakte, :google_oauth2, :yandex, :facebook, :twitter, :odnoklassniki, :mailru]

  def vkontakte
  end

  def google_oauth2
  end

  def yandex
  end

  def facebook
  end

  def twitter
  end

  def odnoklassniki
  end

  def mailru
  end

  def after_sign_in_path_for(resource_or_scope)
    if request.env['omniauth.origin']
      return my_root_path if request.env['omniauth.origin'].match(/my\/sessions\/new/)
      return request.env['omniauth.origin']
    else
      root_path
    end
  end

  private

  def authenticate
    auth_raw_info = request.env['omniauth.auth']
    @user = User.find_or_create_by_oauth(auth_raw_info)

    sign_in @user, :event => :authentication
    @after_sign_in_url = after_sign_in_path_for(@user)

    if @after_sign_in_url.match(/manage/)
      redirect_to(manage_root_path)
    elsif @after_sign_in_url.match(/my\z/)
      redirect_to(my_root_path)
    else
      render('callback', :layout => false)
    end
  end

  def after_omniauth_failure_path_for(scope)
    new_my_session_path(scope)
  end
end
