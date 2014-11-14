# encoding: utf-8

class My::AfishasController < My::ApplicationController
  load_and_authorize_resource
  defaults :resource_class => Afisha

  before_filter :current_step

  actions :all

  def index
    index! {
      @account = AccountDecorator.new(current_user.account)

      @events = @account.afisha.page(1).per(15)
    }
  end

  def show
    @afisha = AfishaDecorator.new(current_user.afisha.find(params[:id]))
  end

  def create
    create! do |success, failure|
      success.html { redirect_to my_afisha_show_path(resource) }
    end
  end

  def edit
    @afisha = current_user.afisha.find(params[:id])
  end

  def update
    @afisha = current_user.afisha.find(params[:id])
    @afisha.step = @step
    @afisha.attributes = params[:afisha]

    if @afisha.save
      if params[:crop]
        redirect_to edit_step_my_afisha_path(@afisha.id, :step => :second)
      else
        redirect_to my_afisha_show_path(@afisha.id)
      end
    else
      render :edit
    end
  end

  def destroy
    destroy! {
      afisha_response = {}
      afisha_response[:all] = current_user.afisha.count
      afisha_response[:published] = current_user.afisha.by_state('published').count
      afisha_response[:draft] = current_user.afisha.by_state('draft').count

      render :json => afisha_response  and return if request.xhr?

      my_root_path
    }
  end

  def available_tags
    @tags = Afisha.available_tags(params[:term])

    respond_to do |format|
      format.json { render text: @tags }
      format.html { render :select_tags }
    end
  end

  def preview_video
    code = params[:afisha].try(:[], :trailer_code)
    code.gsub!(/width=("|')(\d+)("|')/i, 'width="580"')
    code.gsub!(/height=("|')(\d+)("|')/i, 'height="350"')
    render text: Afisha.trailer_auto_html(code)
  end

  def destroy_image
    @afisha = current_user.afisha.find(params[:id])
    @afisha.poster_url = nil
    @afisha.poster_image.destroy
    @afisha.poster_image_url = nil
    @afisha.save(:validate => false)
    redirect_to edit_step_my_afisha_path(@afisha.id, :step => :second)
  end

  def send_to_published
    @afisha = current_user.afisha.find(params[:id])
    @afisha.to_published!

    redirect_to my_afisha_path, :notice => "Афиша «#{@afisha.title}» опубликована."
  end

  def send_to_draft
    @afisha = current_user.afisha.find(params[:id])
    @afisha.to_draft!

    redirect_to [:my, @afisha], :notice => "Афиша «#{@afisha.title}» возвращена в черновики."
  end

  def social_gallery
    @afisha = current_user.afisha.find(params[:id])

    @afisha.download_album(params[:afisha][:social_gallery_url])

    redirect_to edit_step_my_afisha_path(@afisha.id, :step => :fourth)
  end

  private

  alias_method :old_build_resource, :build_resource

  def build_resource
    old_build_resource.tap do |object|
      object.user = current_user
    end
  end

  def current_step
    @step ||= Afisha.steps.include?(params[:step]) ? params[:step] : Afisha.steps.first
  end

  def next_step
    return @step if @afisha.second_step? && !@afisha.set_region?

    Afisha.steps[Afisha.steps.index(current_step) + 1] || Afisha.steps.last
  end
end
