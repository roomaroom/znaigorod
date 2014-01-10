# encoding: utf-8

class Manage::PageMetasController < Manage::ApplicationController
  load_and_authorize_resource

  actions :all

  protected

  def collection
    @page_metas ||= if params[:q]
    else
      PageMeta.page(params[:page]).per(10)
    end
  end
end
