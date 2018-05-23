require 'rails_helper'

describe 'Profile API' do
  describe 'Get /me' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/me', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if there is invalid' do
        get '/api/v1/profiles/me', params: { format: :json, access_token: '123123123' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contains #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles', params: { format: :json }
        expect(response).to have_http_status 401
      end

      it 'returns 401 status if there is invalid' do
        get '/api/v1/profiles', params: { format: :json, access_token: '123456' }
        expect(response).to have_http_status 401
      end
    end

    context 'authorized' do
      let!(:user1) { create(:user) }
      let!(:user2) { create(:user) }
      let!(:user3) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user1.id) }

      before { get '/api/v1/profiles', params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns 2 users' do
        expect(response.body).to have_json_size(2)
      end

      it 'does not contains current_user' do
        expect(response.body).to_not include_json(user1.to_json)
      end

      %w(user2 user3).each do |user|
        it "contains user #{user}" do
          expect(response.body).to include_json(send(user.to_sym).to_json)
        end

        context "#{user} contains attribute" do
          let!(:current_user) { send(user.to_sym) }
          let!(:body) { JSON.parse(response.body).find { |item| item['email'] == current_user.email }.to_json }

          %w(email id created_at updated_at admin).each do |attr|
            it attr do
              expect(body).to be_json_eql(current_user.send(attr.to_sym).to_json).at_path(attr)
            end
          end
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contains #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end
end