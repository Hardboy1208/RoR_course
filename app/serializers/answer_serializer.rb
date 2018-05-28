class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :best

  belongs_to :question
  has_many :attachments
  has_many :comments
end
