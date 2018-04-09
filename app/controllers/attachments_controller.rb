class AttachmentsController < ApplicationController
  def destroy
    attachment = Attachment.find(params[:id])
    if attachment.destroy
      redirect_to attachment.attachmentable.question if attachment.attachmentable.class.name == 'Answer'
      redirect_to attachment.attachmentable if attachment.attachmentable.class.name == 'Question'
    end
  end
end
