class CreateSurveyAnswers < ActiveRecord::Migration
  def change
    create_table :survey_answers do |t|
      t.integer :patient_id
      t.string :status
      t.integer :fid
      t.string :created
      t.string :ip
      t.string :location
      t.string :nps
      t.string :run
      t.string :collector
      t.integer :a1
      t.text :c1
      t.integer :a2
      t.string :b2
      t.integer :a3
      t.text :c3
      t.integer :a4
      t.text :c4
      t.integer :a5
      t.text :c5
      t.integer :a6
      t.text :c6
      t.integer :a7
      t.text :c7
      t.integer :a8
      t.text :c8
      t.integer :n1
      t.integer :n2
      t.integer :n3
      t.text :c9
      t.integer :practice_id
      t.integer :run_id
      t.string :duration

      t.timestamps
    end
  end
end
