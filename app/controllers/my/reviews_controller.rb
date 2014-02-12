class My::ReviewsController < My::ApplicationController
  # TODO: написать ability
  skip_authorization_check

  actions :all, :except => :index

  custom_actions :resource => :add_images

  def show
    show!{
      @review = ReviewDecorator.new(@review)
    }
  end

  def preview
    build_resource

    render :partial => "reviews/review", :locals => { :review => ReviewDecorator.new(@review) }
  end

  protected

  def build_resource
    klass = Reviews::VerifiedClass.new(type: params[:type]).klass

    @review = klass.new(params[:review])
  end

  def resource_url
    @review.is_a?(ReviewPhoto) ?
      images_add_my_review_path(@review) :
      my_review_path(@review)
  end
end
