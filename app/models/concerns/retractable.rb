module Retractable
  extend ActiveSupport::Concern

  included do
    has_many :ratings, as: :retractable
  end

  def all_likes
    self.ratings.where(like: true).count
  end

  def all_dislikes
    self.ratings.where(like: false).count
  end

  def diff_like
    self.all_likes - self.all_dislikes
  end
end