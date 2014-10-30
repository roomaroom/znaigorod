class Manage::MainPagePostersController < Manage::ApplicationController
  load_and_authorize_resource

  actions :all, :except => [:new, :create, :show, :destroy]

  def index
    @main_page_poster = MainPagePoster.ordered

    search = Afisha.search { fulltext params[:term]; with :state, :published }
    afishas = search.results

    respond_to do |format|
      format.html
      format.json { render :json => afishas.map { |r|  { :label => r.title, :value => r.id } } }
    end
  end
end
