class CreateClinics < ActiveRecord::Migration
  def change
    create_table :clinics do |t|
      t.integer :practice_id
      t.string :name

      t.timestamps
    end
  end
end
