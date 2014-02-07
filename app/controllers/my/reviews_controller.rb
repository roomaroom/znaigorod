class My::ReviewsController < My::ApplicationController
  # TODO: написать ability
  skip_authorization_check

  actions :new, :create

  def create
    raise params.inspect
  end

  protected

  def build_resource
    klass = Reviews::VerifiedClass.new(type: params[:type]).klass

    @review = klass.new(params[:review])
  end
end
