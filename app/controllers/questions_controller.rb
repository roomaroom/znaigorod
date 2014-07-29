class QuestionsController < ApplicationController
  def index
    @presenter = QuestionsPresenter.new(params)
  end

  def show
    @presenter = QuestionsPresenter.new(params)
  end
end
