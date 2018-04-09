require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    sign_in_user

    context 'user try to delete file from his own question' do
      let!(:question) { create(:question, user: @user) }

      it 'delete file' do
        attachment = question.attachments.create(file: File.open("#{Rails.root}/spec/spec_helper.rb"))
        expect { delete :destroy, params: { id: attachment.id } }.to change(question.attachments, :count).by(-1)
      end

      it 'redirects to question show view' do
        attachment = question.attachments.create(file: File.open("#{Rails.root}/spec/spec_helper.rb"))
        delete :destroy, params: { id: attachment.id }

        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
