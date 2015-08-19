class CreateSurveyResults < ActiveRecord::Migration
  def change
    create_table :survey_results do |t|
      t.integer :patient_id
      t.string :status
      t.integer :fid
      t.string :created
      t.string :ip
      t.string :location
      t.integer :nps
      t.string :run
      t.string :collector
      t.integer :a1
      t.integer :a2
      t.integer :a3
      t.integer :a4
      t.integer :a5
      t.text :a6comment
      t.text :posfeedback
      t.integer :b1
      t.integer :b2
      t.integer :b3
      t.integer :b4
      t.integer :b5
      t.text :b6comment
      t.boolean :contact
      t.text :negfeedback

      t.timestamps
    end
  end
end
