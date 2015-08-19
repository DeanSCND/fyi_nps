class PracticeGroup < ActiveRecord::Base
  has_many :clinics
  
  def get_invites(run_id)
    practices = self.clinics
    pArray = practices.map(&:practice_id)
    invites = Patient.where(:run_id=>run_id, :practice_id=>pArray)

    return invites    
  end
  
  def get_all_invites
    practices = self.clinics
    pArray = practices.map(&:practice_id)
    invites = Patient.where(:practice_id=>pArray).where("run_id >= 14")

    return invites    
  end

  def get_answers(run_id)
    practices = self.clinics
    pArray = practices.map(&:practice_id)

    results = SurveyAnswer.where(:run_id=>run_id, :practice_id => pArray, :status=>"Complete")

	  return results
	end

  def get_all_answers
    practices = self.clinics
    pArray = practices.map(&:practice_id)

    results = SurveyAnswer.where(:practice_id => pArray, :status=>"Complete").where("run_id >= 14")

    return results
  end

  def get_rolling_invites(run_id)
    practices = self.clinics
    pArray = practices.map(&:practice_id)
    invites = Patient.where("run_id >= ?", run_id).where("run_id >= 14").where(:practice_id=>pArray)

    return invites
  end

  def get_rolling_answers(run_id)
    practices = self.clinics
    pArray = practices.map(&:practice_id)

    results = SurveyAnswer.where("run_id >= ?", run_id).where(:practice_id => pArray, :status=>"Complete")

    return results

  end

end
