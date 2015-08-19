class CreateRuns < ActiveRecord::Migration
  def change
    create_table :runs do |t|
      t.string :name
      t.string :month
      t.string :year

      t.timestamps
    end
  end
end
