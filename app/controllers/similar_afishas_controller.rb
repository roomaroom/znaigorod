class SimilarAfishasController < ApplicationController
  def index
    unless params[:title].empty?
      afisha_ids = HasSearcher.searcher(:showings, :q => params[:title]).actual.paginate(:page => 1, :per_page => 2).groups.group(:afisha_id_str).groups.map(&:value)
      @afishas = Afisha.where(:id => afisha_ids).decorate
      unless @afishas.empty?
        render :partial => "my/afishas/similar_afishas"
      else
        render :text => ""
      end
    end
  end
end
