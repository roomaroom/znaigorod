class TeasersController < ApplicationController
  layout false

  def show
    @teaser = Teaser.find(params[:id])
  end
end
