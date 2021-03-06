class Manage::PoolTablesController < Manage::ApplicationController
  load_and_authorize_resource

  actions :all, :except => [:index, :show]

  belongs_to :organization do
    belongs_to :billiard, :singleton => true
  end

  def destroy
    destroy! { [:manage, @organization] }
  end

  private

  def smart_resource_url
    [:manage, @organization]
  end
end
