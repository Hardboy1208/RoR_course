class Answer < ApplicationRecord
  include Retractable

  belongs_to :question, touch: true
  belongs_to :user
  has_many :attachments, as: :attachmentable
  has_many :comments, as: :commentable

  validates :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  scope :sorted, -> { order('best DESC, created_at DESC') }

  after_create :user_subscription

  def choose_the_best
    transaction do
      self.question.answers.update_all(best: false)
      self.update!(best: true)
    end
  end

  def user_subscription
    UserSubscriptionsJob.perform_later
  end
end
