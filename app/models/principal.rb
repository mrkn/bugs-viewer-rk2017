class Principal < ActiveRecord::Base
  self.table_name = "#{table_name_prefix}users#{table_name_suffix}"

  # Account statuses
  STATUS_ANONYMOUS  = 0
  STATUS_ACTIVE     = 1
  STATUS_REGISTERED = 2
  STATUS_LOCKED     = 3

  scope :active, -> { where(status: STATUS_ACTIVE) }

  scope :admin, -> { where(admin: true) }
end
