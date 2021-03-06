require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }


      before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_success
      end
      
      it 'returns list of questions' do
        expect(response.body).to have_json_size(2)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
      
      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("0/short_title")
      end
      
      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/answers/0/#{attr}")
          end
        end
      end
    end
  end

  def do_request(options = {})
    get '/api/v1/questions', params: { format: :json }.merge(options)
  end

  describe 'GET /show' do
    let!(:question) { create(:question) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}", params: { format: :json }
        expect(response).to have_http_status 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:comment) { Comment.create(commentable: question, user: create(:user)) }
      let!(:attachment) { create(:attachment, attachmentable: question) }

      before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns question' do
        expect(response.body).to include_json("#{question.id}")
      end

      %w(id title body created_at updated_at comments).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      it 'question object contains url attachments' do
        expect(response.body).to be_json_eql(question.send('attachments'.to_sym).first.file.url.to_json).at_path('attachments/0/file/url')
      end
    end
  end

  describe 'POST /create' do
    context 'authorized' do
      let(:access_token) { create(:access_token) }

      context 'with valid question params' do
        before { post "/api/v1/questions", params: { format: :json, question: attributes_for(:question), access_token: access_token.token } }

        it 'return 201 status code' do
          expect(response).to have_http_status 201
        end

        %w(title body).each do |attr|
          it "question object contains #{attr}" do
            expect(response.body).to be_json_eql(Question.last.send(attr.to_sym).to_json).at_path(attr)
          end
        end
      end

      context 'with invalid question params' do
        before { post "/api/v1/questions", params: { format: :json, question: attributes_for(:invalid_question), access_token: access_token.token } }

        %w(title body).each do |attr|
          it "return #{attr} errors" do
            expect(response.body).to be_json_eql("can't be blank".to_json).at_path("errors/#{attr}/0")
          end
        end
      end
    end
  end
end