class QuestionsController < ApplicationController
  include Retracted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :user_is_author?, only: [:destroy]

  after_action :publish_question, only: [:create]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
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

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      { author: current_user, question: @question }
    )
  end

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
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end
end
