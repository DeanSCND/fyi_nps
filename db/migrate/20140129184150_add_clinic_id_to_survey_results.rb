class AddClinicIdToSurveyResults < ActiveRecord::Migration
  def change
    add_column :survey_results, :practice_id, :integer
  end
end
