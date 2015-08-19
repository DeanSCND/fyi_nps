class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.string :run
      t.integer :count
      t.string :month
      t.string :status

      t.timestamps
    end
  end
end
