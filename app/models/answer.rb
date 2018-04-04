class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :sorted, -> { order('best DESC, created_at DESC') }

  def choose_the_best
    transaction do
      self.question.answers.update_all(best: false)
      self.update!(best: true)
    end
  end
end
