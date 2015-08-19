class AddDurationToSurveyResults < ActiveRecord::Migration
  def change
    add_column :survey_results, :duration, :string
  end
end
