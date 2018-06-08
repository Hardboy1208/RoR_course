class UserSubscriptionsJob < ApplicationJob
  queue_as :mailers

  def perform
    Subscription.send_subscription
  end
end
