require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :attachments }

  describe '#diff_like' do
    let!(:question) { create(:question_with_ratings) }

    it 'Then see voted result on the answer' do
      expect(question.diff_like).to eq question.ratings.sum(:like)
    end
  end
end
