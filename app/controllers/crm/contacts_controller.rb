class Crm::ContactsController < Crm::ApplicationController
  load_and_authorize_resource

  actions :all, :except => [:show]

  belongs_to :organization

  def destroy
    destroy! { render :index and return }
  end
end
