require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  describe 'User#author_of?' do
    let(:user) { create(:user_with_question_and_answers) }
    let(:question) { create(:question_for_answers) }

    it 'User the author of his question' do
      expect(user).to be_author_of(user.questions.first)
    end

    it 'User not the author of alien question' do
      expect(user.author_of?(question)).to be_falsey
    end
  end
end
