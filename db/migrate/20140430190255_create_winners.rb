class CreateWinners < ActiveRecord::Migration
  def change
    create_table :winners do |t|
      t.integer :run_id
      t.integer :patient_id
      t.integer :practice_id
      t.string :name
      t.string :witness

      t.timestamps
    end
  end
end
