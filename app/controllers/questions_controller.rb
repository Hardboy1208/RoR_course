class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answers = Answer.all
    @answer  = Answer.new
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(questions_params)

    if @question.save
      flash[:notice] = 'Your question successfully created.'
      redirect_to @question
    else
      render :new
    end
  end

  def destroy
    if @question.user == current_user
      if @question.destroy
        flash[:notice] = 'Your question successfully deleted.'
        redirect_to root_path
      else
        flash[:danger] = 'Your question not deleted.'
        redirect_to @question
      end
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def questions_params
    params.require(:question).permit(:title, :body, :user_id)
  end
end
