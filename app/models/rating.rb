class Rating < ApplicationRecord
  belongs_to :retractable, polymorphic: true, optional: true
end
