class My::ReviewsController < My::ApplicationController
  # TODO: написать ability
  skip_authorization_check

  actions :all, :except => :index

  def preview
    build_resource

    render :partial => "reviews/#{@review.useful_type}"
  end

  protected

  def build_resource
    klass = Reviews::VerifiedClass.new(type: params[:type]).klass

    @review = klass.new(params[:review])
  end
end
