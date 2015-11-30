class Distribution < ActiveRecord::Base
  belongs_to :distribution_clinic
  has_many :fyi_contacts, through :distribution_contacts
end
