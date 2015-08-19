class CreatePracticeReports < ActiveRecord::Migration
  def change
    create_table :practice_reports do |t|
      t.integer :practice_id
      t.integer :practice_group_id
      t.integer :run_id
      t.float :n1
      t.float :n2
      t.float :n3
      t.float :a1
      t.float :a2
      t.float :a3
      t.float :a4
      t.float :a5
      t.float :a6
      t.float :a7
      t.float :a8
      t.float :response_rate

      t.timestamps
    end
  end
end
