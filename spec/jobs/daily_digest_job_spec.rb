require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  it 'sends daily digest' do
    expect(User).to receive(:send_daily_digest).and_call_original
    DailyDigestJob.perform_now
  end
end

