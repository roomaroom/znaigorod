class SimilarAfishasController < ApplicationController
  def index
    afisha_ids = HasSearcher.searcher(:showings, :q => params[:title]).actual.groups.group(:afisha_id_str).groups.map(&:value)
    #@afishas = AfishaDecorator.new Afisha.where(:id => afisha_ids)
    @afishas = Afisha.where(:id => afisha_ids).decorate
    unless @afishas.empty?
      render :partial => "my/afishas/similar_afishas"
    else
      render :text => ""
    end
  end
end
