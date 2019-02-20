class FeedbacksController < ApplicationController
  def create
    @feedback = Feedback.create(feedback_params)
  end

  private

  def feedback_params
    params.require(:feedback).permit(:name, :phone, :email, :message)
  end
end
