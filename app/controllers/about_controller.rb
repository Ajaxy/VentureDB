# encoding: utf-8

class AboutController < CabinetController
  def index
  end

  def feedback
    @feedback = Feedback.create(permitted_params.feedback)
    FeedbackMailer.notify(@feedback).deliver
    render :index
  end
end
