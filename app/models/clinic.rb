class Clinic < ActiveRecord::Base
  has_many :patients, :foreign_key => 'run_id'
  has_many :survey_answer
  has_many :practice_report

  def nps(run_id)
    pos = SurveyResult.select("count(id) as count").where(:practice_id => self.id, :run_id => run_id)
    
    return pos.first[0][:count]
  end
end
