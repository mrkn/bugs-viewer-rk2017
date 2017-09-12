class Project < ApplicationRecord
  def self.trunk
    Project.find(1)
  end

  has_many :members, -> { joins(:principal).merge(User.active) }
  has_many :issues
end
