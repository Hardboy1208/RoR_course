class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :user_is_author?, only: [:destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.new(questions_params)
    if @question.save
      flash[:notice] = 'Your question successfully created.'
      redirect_to @question
    else
      render :new
    end
  end

  def edit
    if current_user.author_of?(@question)
      render :edit
    end
  end

  def update
    if current_user.author_of?(@question)
      @question.update(questions_params)
    end
  end

  def destroy
    if @question.destroy
      flash[:notice] = 'Your question successfully deleted.'
      redirect_to root_path
    else
      flash[:danger] = 'Your question not deleted.'
      redirect_to @question
    end
  end

  private

  def user_is_author?
    unless current_user.author_of?(@question)
      flash[:danger] = 'You not author question.'
      redirect_to @question
    end
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def questions_params
    params.require(:question).permit(:title, :body)
  end
end
