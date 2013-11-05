# encoding: utf-8

class My::DiscountsController < My::ApplicationController
  load_and_authorize_resource

  actions :all, :except => :index

  custom_actions :resource => [:poster, :send_to_published, :send_to_draft]

  def show
    @discount = DiscountDecorator.new(@discount)
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

  def send_to_published
    @discount = current_user.account.discounts.available_for_edit.find(params[:id])
    @discount.to_published!

    redirect_to discount_path(@discount), :notice => "Информация о скидке «#{@discount.title}» опубликована."
  end

  def send_to_draft
    @discount = current_user.account.discounts.available_for_edit.find(params[:id])
    @discount.to_draft!

    redirect_to my_discount_path(@discount), :notice => "Информация о скидке «#{@discount.title}» возвращена в черновики."
  end

  private
    alias_method :old_build_resource, :build_resource

    def build_resource
      old_build_resource.tap do |object|
        object.account = current_user.account
      end
    end
end
