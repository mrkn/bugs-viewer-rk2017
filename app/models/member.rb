class Member < ApplicationRecord
  belongs_to :user
  belongs_to :principal, foreign_key: :user_id
  belongs_to :project
end
