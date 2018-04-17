module Retractable
  extend ActiveSupport::Concern

  included do
    has_many :ratings, as: :retractable
  end

  def diff_like
    self.ratings.sum(:like)
  end
end