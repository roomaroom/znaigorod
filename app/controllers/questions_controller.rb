class QuestionsController < ApplicationController
  def index
    respond_to do |format|
      format.html {
        @presenter = QuestionsPresenter.new(params)

        render :partial => 'questions/list', :locals => { :collection => @presenter.collection }, :layout => false and return if request.xhr?
      }

      format.promotion {
        presenter = QuestionsPresenter.new(params.merge(:per_page => 5))

        render :partial => 'promotions/questions', :locals => { :presenter => presenter }
      }
    end

  end

  def show
    @question = QuestionDecorator.new(Question.find(params[:id]))

    respond_to do |format|
      format.html {
        @presenter = QuestionsPresenter.new(params.merge(:category => @question.categories.map(&:value).first))
        @question.delay(:queue => 'critical').create_page_visit(request.session_options[:id], request.user_agent, current_user)
      }

      format.promotion {
        render :partial => 'promotions/question', :locals => { :decorated_question => @question }
      }
    end
  end
end
