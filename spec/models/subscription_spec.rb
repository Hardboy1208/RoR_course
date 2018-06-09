require "rails_helper"

RSpec.describe Subscription, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:question) }

  describe '.send_daily_digest' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:subscription) { create(:subscription, question: question, user: user) }

    it 'should send daily digest to all users' do
      expect(UserSubscriptionsMailer).to receive(:send_mail).with(user, question).and_call_original
      Subscription.send_subscription
    end
  end
end