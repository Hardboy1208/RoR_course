module Retractable
  extend ActiveSupport::Concern

  included do
    has_many :ratings, as: :retractable
  end

  def all_likes
    self.ratings.where(like: 1).count
  end

  def all_dislikes
    self.ratings.where(like: -1).count
  end

  def diff_like
    self.ratings.sum(:like)
  end
end