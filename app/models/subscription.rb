class Subscription < ApplicationRecord
  belongs_to :question
  belongs_to :user

  def self.send_subscription
    find_each.each do |subscription|
      UserSubscriptionsMailer.send_mail(subscription, subscription.question).deliver_later
    end
  end
end