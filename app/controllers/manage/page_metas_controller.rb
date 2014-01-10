# encoding: utf-8

class Manage::PageMetasController < Manage::ApplicationController
  load_and_authorize_resource

  actions :all

  protected

  def collection
    @page_metas ||= if params[:q]
      PageMeta.where("path ILIKE ?", "%#{params[:q]}%").page(params[:page]).per(10)
    else
      PageMeta.page(params[:page]).per(10)
    end
  end
end
