class Question < ApplicationRecord
  include Retractable

  scope :sorted, -> { order('created_at DESC') }
  scope :for_last_day, -> { where('created_at >= ?', 1.day.ago) }

  has_many :answers, dependent: :destroy
  has_many :comments, as: :commentable
  has_many :attachments, as: :attachmentable
  has_many :subscriptions, dependent: :destroy

  belongs_to :user

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  after_create :author_subscription

  private

  def author_subscription
    self.subscriptions.create(user_id: self.user_id)
  end
end

