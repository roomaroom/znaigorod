#encoding: utf-8

class FeedbackController < ApplicationController

  def new
    @feedback = Feedback.new(params[:feedback])
  end

  def create
    @feedback = Feedback.new(params[:feedback])
    if verify_recaptcha(:model => @feedback) && @feedback.save
      redirect_to new_feedback_path, :notice => 'Сообщение отправлено успешно, спасибо за обращение.'
    else
      @feedback.valid?
      render :new
    end
  end

end
