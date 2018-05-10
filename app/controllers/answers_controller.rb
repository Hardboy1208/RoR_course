class AnswersController < ApplicationController
  include Retracted

  before_action :authenticate_user!
  before_action :set_question, only: [:create]
  before_action :set_answer, only: [:update, :destroy, :choose_the_best]

  after_action :publish_answer, only: [:create]

  respond_to :js
  respond_to :json, only: :create

  def create
    respond_with(@answer = current_user.answers.create(answer_params.merge({ question: @question })))
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      respond_with @answer
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      respond_with @answer.destroy
    end
  end

  def choose_the_best
    if current_user.author_of?(@answer.question)
      @answer.choose_the_best
    end
  end

  private

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
        "answers-#{@answer.question_id}",
        { answer: @answer }
    )
  end

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