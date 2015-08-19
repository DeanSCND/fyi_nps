class AddRunIdToSurveyResults < ActiveRecord::Migration
  def change
    add_column :survey_results, :run_id, :integer
  end
end
