require 'rails_helper'

RSpec.describe UserSubscriptionsJob, type: :job do
  it 'send notify to subscribed user' do
    expect(Subscription).to receive(:send_subscription).and_call_original
    UserSubscriptionsJob.perform_now
  end
end
