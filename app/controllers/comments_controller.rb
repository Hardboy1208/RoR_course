class CommentsController < ApplicationController
  before_action :load_commentable, only: [:create]
  after_action :publish_comment, only: [:create]

  def create
    @comment = @commentable.comments.new(comments_params.merge({ user_id: current_user.id }))
    @comment.save
  end

  private

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast(
        "comments-#{@comment.question.id}",
        { author: current_user, comment: @comment, question_id: @comment.question.id  }
    )
  end

  def load_commentable
    @commentable = Answer.find(params[:answer_id]) if params[:answer_id]
    @commentable = Question.find(params[:question_id]) if params[:question_id]
  end

  def comments_params
    params.require(:comment).permit(:body)
  end
end
