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
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'the question belongs to the user' do
        post :create, params: { question: attributes_for(:question) }
        expect(assigns(:question).user_id).to eq @user.id
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'when invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
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
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
  end

  describe 'rating' do
    sign_in_user

    let(:author_question) { create(:question, user: @user) }
    let(:not_author_object) { question }
    let(:author_object) { author_question }

    it_behaves_like 'Ratingable'
  end
end
