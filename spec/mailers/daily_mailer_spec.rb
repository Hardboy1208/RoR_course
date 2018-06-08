require "rails_helper"

RSpec.describe DailyMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let(:questions) { create_list(:question, 2) }
    let(:mail) { DailyMailer.digest(user, questions) }

    it "renders the headers" do
      expect(mail.subject).to eq("Daily mail with new questions!")
      expect(mail.to).to eq(["#{user.email}"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
      expect(mail.body.encoded).to match(questions[0].title)
      expect(mail.body.encoded).to match(questions[1].title)
      expect(mail.body.encoded).to match(question_url(questions[0]))
      expect(mail.body.encoded).to match(question_url(questions[1]))
    end
  end
end
