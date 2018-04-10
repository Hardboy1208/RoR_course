class Attachment < ApplicationRecord
  mount_uploader :file, FileUploader

  belongs_to :attachmentable, polymorphic: true, optional: true

  def question
    self.attachmentable.respond_to?(:question) ? self.attachmentable.question : self.attachmentable
  end
end
