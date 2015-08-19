class CreatePatients < ActiveRecord::Migration
  def change
    create_table :patients do |t|
      t.string :name
      t.string :email
      t.integer :practice_id
      t.string :practice_name
      t.date :visitDate

      t.timestamps
    end
  end
end
