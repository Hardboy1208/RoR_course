class AttachmentsController < ApplicationController
  def destroy
    attachment = Attachment.find(params[:id])
    if current_user.author_of?(attachment.attachmentable)
      if attachment.destroy
        redirect_to attachment.question
      end
    end
  end
end
