class QuestionsController < ApplicationController
  include Retracted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :user_is_author?, only: [:destroy]
  before_action :build_answer, only: :show

  after_action :publish_question, only: [:create]

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with(@question = current_user.questions.create(questions_params))
  end

  def edit
    if current_user.author_of?(@question)
      render :edit
    end
  end

  def update
    if current_user.author_of?(@question)
      @question.update(questions_params)
      respond_with @question
    end
  end

  def destroy
    respond_with @question.destroy

    # if @question.destroy
    #   flash[:notice] = 'Your question successfully deleted.'
    #   redirect_to root_path
    # else
    #   flash[:danger] = 'Your question not deleted.'
    #   redirect_to @question
    # end
  end

  private

  def build_answer
    @answer = Answer.new
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
