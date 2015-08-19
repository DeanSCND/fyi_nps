class Run < ActiveRecord::Base
  has_many :patients
  has_many :practice_reports
end
