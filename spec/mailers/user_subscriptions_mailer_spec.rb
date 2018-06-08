require "rails_helper"

RSpec.describe DailyMailer, type: :mailer do
  describe "subscription" do
    let(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let(:mail) { UserSubscriptionsMailer.send_mail(user, question) }

    it "renders the headers" do
      expect(mail.subject).to eq("New answer on question")
      expect(mail.to).to eq(["#{user.email}"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
      expect(mail.body.encoded).to match(question.title)
      expect(mail.body.encoded).to match(question_url(question))
      expect(mail.body.encoded).to match(answer.body)
    end
  end
end
