require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question_for_answers, user: user) }
  let(:answer) { question.answers.first }

  describe 'POST #create' do
    sign_in_user
    let(:comments) { question.answers.first.comments }

    context 'with valid attributes' do
      it 'does save the new answer for question' do
        expect { post :create, params: { answer_id: answer, comment: attributes_for(:comment), format: :js } }.to change(comments, :count).by(1)
      end

      it 'the answer belongs to the user' do
        post :create, params: { answer_id: answer, comment: attributes_for(:comment), format: :js }
        expect(assigns(:comment).user_id).to eq @user.id
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new answer for question' do
        expect { post :create, params: { answer_id: answer, comment: attributes_for(:invalid_comment), format: :js } }.to_not change(Comment, :count)
      end
    end
  end
end
