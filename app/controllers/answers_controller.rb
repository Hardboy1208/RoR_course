class AnswersController < ApplicationController
  before_action :set_question
  before_action :set_answer, only: [:show, :destroy]

  def index
    @answers = @question.answers
  end

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      flash[:notice] = 'Your answer successfully created.'
      redirect_to @question
    else
      render :new
    end
  end

  def show; end

  def destroy
    if @answer.destroy
      flash[:notice] = 'Your answer successfully deleted.'
      redirect_to @question
    else
      flash[:notice] = 'Your answer successfully deleted.'
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
    params.require(:answer).permit(:body, :question_id, :user_id)
  end
end