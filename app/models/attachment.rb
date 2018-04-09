class Attachment < ApplicationRecord
  mount_uploader :file, FileUploader

  belongs_to :attachmentable, polymorphic: true, optional: true

  def question
    self.attachmentable.methods.include?(:question) ? self.attachmentable.question : self.attachmentable
  end
end
