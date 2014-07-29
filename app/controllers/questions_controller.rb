class QuestionsController < ApplicationController
  def index
    @presenter = QuestionsPresenter.new(params)
  end

  def show
    @presenter = QuestionsPresenter.new(params)
    question = Question.find(params[:id])
    @question = ReviewDecorator.new(question)
  end
end
