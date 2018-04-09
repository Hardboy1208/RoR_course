class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachmentable

  validates :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  scope :sorted, -> { order('best DESC, created_at DESC') }

  def choose_the_best
    transaction do
      self.question.answers.update_all(best: false)
      self.update!(best: true)
    end
  end
end
