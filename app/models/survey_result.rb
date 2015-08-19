class SurveyResult < ActiveRecord::Base
  belongs_to :patient
  belongs_to :run
  validates_uniqueness_of :patient_id

end
