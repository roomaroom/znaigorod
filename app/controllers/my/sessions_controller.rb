class My::SessionsController < ApplicationController

  def new
    render :partial => 'commons/social_auth' if request.xhr?
  end
end
