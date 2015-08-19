class SurveyAnswer < ActiveRecord::Base
  belongs_to :patient
  belongs_to :clinic, :foreign_key=>:practice_id
  belongs_to :run
  validates_uniqueness_of :patient_id

end
