module Retracted
  extend ActiveSupport::Concern

  included do
    before_action :load_retractable, only: [:rating_up, :rating_down, :rating_reset]
  end

  def rating_up
    respond_to do |format|
      if !current_user.author_of?(@retractable) && !current_user.already_voted?(@retractable)
        if @retractable.ratings.create(user_id: current_user.id, like: 1)
          format.json { render json: { retractable_id: @retractable.id, voted: true, diff_like: @retractable.diff_like, message: 'The vote was successful' } }
        end
      else
        format.json { render json: { retractable_id: @retractable.id, voted: false, diff_like: @retractable.diff_like, message: 'The vote was unsuccessful' }, status: :unprocessible_entity }
      end
    end
  end

  def rating_down
    respond_to do |format|
      if !current_user.author_of?(@retractable) && !current_user.already_voted?(@retractable)
        if @retractable.ratings.create(user_id: current_user.id, like: -1)
          format.json { render json: { retractable_id: @retractable.id, voted: true, diff_like: @retractable.diff_like, message: 'The vote was successful' } }
        end
      else
        format.json { render json: { retractable_id: @retractable.id, voted: false, diff_like: @retractable.diff_like, message: 'The vote was unsuccessful' }, status: :unprocessible_entity }
      end
    end
  end

  def rating_reset
    respond_to do |format|
      if !@retractable.ratings.find_by(user_id: current_user.id).nil? && current_user.already_voted?(@retractable)
        if @retractable.ratings.find_by(user_id: current_user.id).destroy
          format.json { render json: { retractable_id: @retractable.id, voted: false, diff_like: @retractable.diff_like, message: 'The voice is dropped' } }
        end
      else
        format.json { render json: { retractable_id: @retractable.id, voted: true, diff_like: @retractable.diff_like, message: 'the voice is not dropped' }, status: :unprocessible_entity }
      end
    end
  end

  def load_retractable
    @retractable = controller_name.classify.constantize.find(params[:id])
  end

  def question_path(retractable)
    retractable.respond_to?(:question) ? retractable.question : questions_path
  end
end