class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question
  before_action :set_answer, only: [:show, :destroy]
  before_action :user_is_author?, only: [:destroy]

  def create
    @answer = current_user.answers.new(answer_params.merge({ question: @question }))

    flash[:notice] = @answer.save ? 'Your answer successfully created.' : 'Your answer not created.'
  end

  def destroy
    if @answer.destroy
      flash[:notice] = 'Your answer successfully deleted.'
      redirect_to @question
    else
      flash[:notice] = 'Your answer successfully deleted.'
      render "questions/show"
    end
  end

  private

  def user_is_author?
    unless current_user.author_of?(@answer)
      flash[:danger] = 'You not author question.'
      redirect_to @question
    end
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end