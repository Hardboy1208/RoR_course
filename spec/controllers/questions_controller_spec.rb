require 'rails_helper'

describe QuestionsController do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2, user: user) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assign a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'when valid attributes' do
      it 'saves the new question in the database' do
        expect { post :create, params: { question: attributes_for(:question, user_id: @user.id) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question, user_id: @user.id) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'when invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:invalid_question, user_id: @user.id) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:invalid_question, user_id: @user.id) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    let(:question_with_author) { create(:question, user: @user) }

    context 'Author deleting question' do
      it 'should delete author`s question' do
        question_with_author
        expect { delete :destroy, params: { id: question_with_author } }.to change(Question, :count).by(-1)
      end

      it 'redirects to question index view' do
        delete :destroy, params: { id: question_with_author }
        expect(response).to redirect_to root_path
      end
    end

    context 'Non-author deleting question' do
      it 'question destroy' do
        question
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end
    end
  end
end
