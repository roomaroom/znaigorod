class My::ReviewsController < My::ApplicationController
  # TODO: написать ability
  skip_authorization_check

  actions :all, :except => :index

  custom_actions :resource => [:add_images, :edit_poster, :send_to_published, :send_to_draft]

  def show
    show!{
      @review = ReviewDecorator.new(@review)
    }
  end

  def preview
    build_resource

    render :partial => "reviews/review", :locals => { :review => ReviewDecorator.new(@review) }
  end

  def send_to_published
    @review = current_user.account.reviews.draft.find(params[:id])
    @review.to_published!

    redirect_to review_path(@review), :notice => "Обзор «#{@review.title}» опубликован."
  end

  def send_to_draft
    @review = current_user.account.reviews.published.find(params[:id])
    @review.to_draft!

    redirect_to my_review_path(@review), :notice => "Обзор «#{@review.title}» возвращен в черновики."
  end

  protected

  def begin_of_association_chain
    current_user.account
  end

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
