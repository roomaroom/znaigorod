class Manage::ReviewsController < Manage::ApplicationController
  load_and_authorize_resource

  actions :all, :except => [:new, :create]

  custom_actions :resource => [:add_images, :send_to_published, :send_to_draft, :edit_poster]

  has_scope :page, :default => 1

  def show
    show! {
      @review = ReviewDecorator.decorate(@review)
    }
  end

  def update
    update! do |success, failure|
      success.html {
        redirect_to params[:crop] ? poster_edit_manage_review_path(resource) : manage_review_path(resource)
      }

      failure.html {
        render params[:crop] ? :edit_poster : :edit
      }
    end
  end

  def send_to_published
    send_to_published!{
      @review.to_published!
      redirect_to manage_review_path(@review), :notice => "Обзор «#{@review.title}» опубликован." and return
    }
  end

  def send_to_draft
    send_to_draft!{
      @review.to_draft!
      redirect_to manage_review_path(@review), :notice => "Обзор «#{@review.title}» возвращен в черновики." and return
    }
  end

  private

  def collection
    @collection = Review.search {
      keywords params[:q]
      order_by :created_at, :desc
      paginate paginate_options.merge(:per_page => per_page)
    }.results
  end
end
