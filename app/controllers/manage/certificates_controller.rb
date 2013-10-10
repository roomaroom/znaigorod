class Manage::CertificatesController < Manage::ApplicationController
  actions :all, :except => [:index, :show, :destroy]

  def create
    create! { manage_discount_path resource }
  end

  def update
    update! { manage_discount_path resource }
  end
end
