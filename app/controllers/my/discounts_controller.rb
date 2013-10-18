# encoding: utf-8

class My::DiscountsController < My::ApplicationController

  load_and_authorize_resource

  actions :new, :create, :show, :edit, :update, :destroy
  custom_actions :resource => :poster

  def show
    show! {
      @discount = DiscountDecorator.new(@discount)
    }
  end

  def update
    update! do |success, failure|
      success.html {
        if params[:crop]
          redirect_to poster_my_discount_path(resource)
        else
          redirect_to my_discount_path(resource)
        end
      }

      failure.html {
        render :poster and return if params[:crop]

        render :edit
      }
    end
  end
end
