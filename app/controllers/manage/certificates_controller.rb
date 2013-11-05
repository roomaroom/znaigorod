class Manage::CertificatesController < Manage::ApplicationController
  load_and_authorize_resource

  actions :all, :except => [:index, :show, :destroy]

  def create
    create! { manage_discount_path resource }
  end

  def update
    update! { manage_discount_path resource }
  end
end
