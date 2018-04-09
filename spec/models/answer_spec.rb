require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should validate_presence_of :body }
  it { should accept_nested_attributes_for :attachments }

  describe '#choose_the_best' do
    let!(:user) { create(:user_with_question_and_five_answers) }

    it 'Then author choose the best answer' do
      answer = user.questions.first.answers.first
      answer.choose_the_best
      expect(answer.best).to be_truthy
    end

    it 'Then author choose the best answer when best answer already exists' do
      best_answer = user.questions.first.answers[0]
      best_answer.choose_the_best
      expect(best_answer).to be_best

      new_best_answer = user.questions.first.answers[1]
      new_best_answer.choose_the_best
      expect(new_best_answer).to be_best

      best_answer.reload
      expect(best_answer).to_not be_best
    end
  end
end
