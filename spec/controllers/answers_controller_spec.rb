require 'rails_helper'

describe AnswersController do
  let(:user) { create(:user) }
  let(:question) { create(:question_for_answers, user: user) }
  let(:answer) { question.answers.first }

  describe 'POST #create' do
    sign_in_user
    let(:answers) { question.answers }

    context 'with valid attributes' do
      it 'does save the new answer for question' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to change(answers, :count).by(1)
      end

      it 'the answer belongs to the user' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(assigns(:answer).user_id).to eq @user.id
      end

      it 'redirects to show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      let(:empty_question) { create(:question, user: user) }

      it 'does not save the new answer for question' do
        expect { post :create, params: { question_id: empty_question, answer: attributes_for(:invalid_answer), format: :js } }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: empty_question, answer: attributes_for(:invalid_answer), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    let(:question_with_answer) { create(:question_for_answers, user: @user) }

    context 'Author deleting answer' do
      it 'the number of answers was less' do
        expect { delete :destroy, params: { question_id: question, id: question_with_answer.answers.first.id } }.to change(question_with_answer.answers, :count).by(-1)
      end

      it 'redirects to question show view' do
        delete :destroy, params: { question_id: question_with_answer, id: question_with_answer.answers.first.id }
        expect(response).to redirect_to question_path(question_with_answer)
      end
    end

    context 'another user can delete answer' do
      it 'should not delete user`s answer' do
        expect { delete :destroy, params: { question_id: question.id, id: answer.id } }.to_not change(question.answers, :count)
      end

      it 'redirects to question show view' do
        delete :destroy, params: { question_id: question.id, id: answer.id }
        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
