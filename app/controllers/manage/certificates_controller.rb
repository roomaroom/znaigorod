class Manage::CertificatesController < Manage::ApplicationController
  load_and_authorize_resource

  actions :all, :except => [:index, :show, :destroy]

  def create
    create! { manage_discount_path resource }
  end

  def edit
    edit! {
      render text: params[:id] and return if request.xhr?
    }
  end

  def update
    update! { manage_discount_path resource }
  end
end
