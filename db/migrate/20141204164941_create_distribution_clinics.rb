class CreateDistributionClinics < ActiveRecord::Migration
  def change
    create_table :distribution_clinics do |t|
      t.integer :distribution_id
      t.integer :practice_id

      t.timestamps
    end
  end
end
