class CreatePatientArchives < ActiveRecord::Migration
  def change
    create_table :patient_archives do |t|
      t.string :name
      t.string :email
      t.integer :practice_id
      t.string :practice_name
      t.date :visitDate
      t.string :run
      t.integer :fid
      t.integer :run_id

      t.timestamps
    end
  end
end
