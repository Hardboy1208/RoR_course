class AnswersController < ApplicationController
  include Retracted

  before_action :authenticate_user!
  before_action :set_question
  before_action :set_answer, only: [:update, :destroy, :choose_the_best]

  def create
    @answer = current_user.answers.new(answer_params.merge({ question: @question }))

    flash[:notice] = @answer.save ? 'Your answer successfully created.' : 'Your answer not created.'
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      flash[:notice] = @answer.destroy ? 'Your answer successfully deleted.' : 'Your answer not deleted.'
    end
  end

  def choose_the_best
    if current_user.author_of?(@question)
      @answer.choose_the_best
    end
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end
end