class SimilarAfishasController < ApplicationController
  def index
    unless params[:title].empty?
      afisha_ids = HasSearcher.searcher(:showings, :q => params[:title]).actual.paginate(:page => 1, :per_page => 2).groups.group(:afisha_id_str).groups.map(&:value)
      @afishas = Afisha.where(:id => afisha_ids).decorate
      render :partial => 'my/afishas/similar_afishas', :layout => false and return unless @afishas.empty? && request.xhr?
    else
      render :nothing => true, :status => 200, :content_type => 'text/html' and return
    end

    render :nothing => true, :status => 200, :content_type => 'text/html' and return
  end
end
