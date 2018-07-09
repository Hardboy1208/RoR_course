class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true, optional: true, touch: true
  belongs_to :user

  validates :body, presence: true

  def question
    self.commentable.respond_to?(:question) ? self.commentable.question : self.commentable
  end
end
