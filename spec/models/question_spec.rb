require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :attachments }

  describe '#diff_like' do
    let!(:author) { create(:user_with_question_and_five_answers) }

    it 'Then see voted result on the question' do
      author.questions.first.ratings.create(user_id: author.id, like: 1)
      expect(author.questions.first.diff_like).to eq 1
    end
  end
end
