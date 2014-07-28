class My::QuestionsController < My::ApplicationController
  load_and_authorize_resource

  actions :all

  def preview
    @question = Question.new(params[:question]) do |question|
      question.account = current_user.account
    end

    render :partial => "my/reviews/review", :locals => { :review => ReviewDecorator.new(@question) }
  end
end
