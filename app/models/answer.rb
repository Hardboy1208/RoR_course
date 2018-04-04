class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :sorted, -> { order('best, created_at DESC') }

  def choose_the_best
    transaction do
      self.question.answers.update_all(best: nil)
      self.update!(best: true)
    end
  end
end
