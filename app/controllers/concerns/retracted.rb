module Retracted
  extend ActiveSupport::Concern

  included do
    before_action :load_retractable, only: [:rating_up, :rating_down, :rating_reset]
  end

  def rating_up
    if !current_user.author_of?(@retractable) && !current_user.already_voted?(@retractable)
      if @retractable.ratings.create(user_id: current_user.id, like: true)
        redirect_to question_path(@retractable)
      end
    end
  end

  def rating_down
    if !current_user.author_of?(@retractable) && !current_user.already_voted?(@retractable)
      if @retractable.ratings.create(user_id: current_user.id, like: false)
        redirect_to question_path(@retractable)
      end
    end
  end

  def rating_reset
    if !current_user.author_of?(@retractable) && current_user.already_voted?(@retractable)
      @retractable.ratings.find_by(user_id: current_user.id).destroy
      redirect_to question_path(@retractable)
    end
  end

  def load_retractable
    @retractable = controller_name.classify.constantize.find(params[:id])
  end

  def question_path(retractable)
    retractable.respond_to?(:question) ? retractable.question : questions_path
  end
end