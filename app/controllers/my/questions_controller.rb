class My::QuestionsController < My::ApplicationController
  load_and_authorize_resource

  actions :all

  def create
    create! do |success, failure|
      success.html {
        redirect_to question_path(resource.id)
      }

      failure.html {
        render :new
      }
    end
  end

  def update
    create! do |success, failure|
      success.html {
        redirect_to question_path(resource.id)
      }

      failure.html {
        render :edit
      }
    end
  end

  def index
    index!{
      @presenter = QuestionsPresenter.new(params)
    }
  end

  def preview
    @question = Question.new(params[:question]) do |question|
      question.account = current_user.account
    end

    render :partial => "my/reviews/review", :locals => { :review => ReviewDecorator.new(@question) }
  end

  protected

  def begin_of_association_chain
    current_user.account
  end
end
