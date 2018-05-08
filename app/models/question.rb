class Question < ApplicationRecord
  include Retractable

  scope :sorted, -> { order('created_at DESC') }

  has_many :answers, dependent: :destroy
  has_many :comments, as: :commentable
  has_many :attachments, as: :attachmentable
  belongs_to :user

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank
end

