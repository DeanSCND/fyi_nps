class AddOthersToSurveyAnswers < ActiveRecord::Migration
  def change
    add_column :survey_answers, :a3o, :string
    add_column :survey_answers, :a4o, :string
    add_column :survey_answers, :a5o, :string
    add_column :survey_answers, :a6o, :string
    add_column :survey_answers, :a7o, :string
    add_column :survey_answers, :a8o, :string
    add_column :survey_answers, :n1o, :string
    add_column :survey_answers, :n2o, :string
  end
end
